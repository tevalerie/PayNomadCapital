const { GoogleSpreadsheet } = require("google-spreadsheet");
const { JWT } = require("google-auth-library");

// Create a JWT client using environment variables
const createJWT = () => {
  return new JWT({
    email: process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
    key: process.env.GOOGLE_PRIVATE_KEY.replace(/\\n/g, "\n"),
    scopes: ["https://www.googleapis.com/auth/spreadsheets"],
  });
};

// Initialize and return the Google Sheets document
async function getGoogleSheetsDoc() {
  try {
    const jwt = createJWT();
    const doc = new GoogleSpreadsheet(process.env.GOOGLE_SHEET_ID, jwt);
    await doc.loadInfo();
    return doc;
  } catch (error) {
    console.error("Error initializing Google Sheets:", error);
    throw new Error("Failed to initialize Google Sheets");
  }
}

// Get the applications sheet
async function getApplicationsSheet() {
  const doc = await getGoogleSheetsDoc();
  return doc.sheetsByTitle["Applications"] || doc.sheetsByIndex[0];
}

// Find a user by email
async function findUserByEmail(email) {
  const sheet = await getApplicationsSheet();
  await sheet.loadCells();
  const rows = await sheet.getRows();

  return rows.find((row) => row.email === email);
}

// Add a new application
async function addApplication(userData) {
  const sheet = await getApplicationsSheet();
  return await sheet.addRow(userData);
}

// Update an existing application
async function updateApplication(rowIndex, updates) {
  const sheet = await getApplicationsSheet();
  const rows = await sheet.getRows();
  const row = rows[rowIndex];

  Object.keys(updates).forEach((key) => {
    row[key] = updates[key];
  });

  await row.save();
  return row;
}

// Validate email (check if it's a valid format and not already registered)
async function validateEmail(email) {
  try {
    // Check if email already exists
    const sheet = await getApplicationsSheet();
    const rows = await sheet.getRows();

    const existingUser = rows.find((row) => row.email === email);
    if (existingUser) {
      return { valid: false, message: "Email already registered" };
    }

    return { valid: true };
  } catch (error) {
    console.error("Error validating email:", error);
    throw new Error("Failed to validate email");
  }
}

module.exports = {
  getGoogleSheetsDoc,
  getApplicationsSheet,
  findUserByEmail,
  addApplication,
  updateApplication,
  validateEmail,
};
