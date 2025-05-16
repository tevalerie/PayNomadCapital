const { EmailJSNodeJS } = require("@emailjs/nodejs");
const {
  addApplication,
  findUserByEmail,
  updateApplication,
} = require("./googleSheetClient");

// Define OTP expiry time in minutes
const OTP_EXPIRY_MINUTES = 15;

exports.handler = async (event, context) => {
  // Set CORS headers for preflight requests
  if (event.httpMethod === "OPTIONS") {
    return {
      statusCode: 200,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
      },
      body: "",
    };
  }

  try {
    const data = JSON.parse(event.body);
    const {
      firstName,
      lastName,
      email,
      referralCode,
      otp,
      resend = false,
    } = data;

    // If this is a resend request, we only need email and OTP
    if (resend) {
      if (!email || !otp) {
        return {
          statusCode: 400,
          body: JSON.stringify({
            message: "Email and OTP are required for resend.",
          }),
        };
      }

      // Find the user in Google Sheets
      const existingUser = await findUserByEmail(email);
      if (!existingUser) {
        return {
          statusCode: 404,
          body: JSON.stringify({ message: "User not found." }),
        };
      }

      // Update the OTP in Google Sheets
      const rowIndex = existingUser._rowNumber - 2; // Adjust for 0-indexing and header row
      await updateApplication(rowIndex, {
        otp,
        expiresAt: Date.now() + OTP_EXPIRY_MINUTES * 60 * 1000, // Set expiry time
      });
    } else {
      // Validate required fields for new registration
      if (!firstName || !lastName || !email || !referralCode || !otp) {
        return {
          statusCode: 400,
          body: JSON.stringify({ message: "All fields are required." }),
        };
      }

      // Store user data in Google Sheets
      await addApplication({
        firstName,
        lastName,
        email,
        referralCode,
        otp,
        status: "pending",
        createdAt: new Date().toISOString(),
        expiresAt: Date.now() + OTP_EXPIRY_MINUTES * 60 * 1000, // Set expiry time
      });
    }

    // Initialize EmailJS with public and private keys
    EmailJSNodeJS.init({
      publicKey: process.env.EMAILJS_USER_ID,
      privateKey: process.env.EMAILJS_PRIVATE_KEY,
    });

    // Calculate expiry time for display in email
    const expiryTimeForEmail = new Date(
      Date.now() + OTP_EXPIRY_MINUTES * 60 * 1000,
    ).toLocaleTimeString("en-US", {
      hour: "2-digit",
      minute: "2-digit",
    });

    // Send email with OTP using EmailJS
    const templateParams = {
      to_email: email,
      to_name: firstName || "there",
      otp: otp,
      is_resend: resend ? true : false,
      current_year: new Date().getFullYear(),
      expiry_time: expiryTimeForEmail,
    };

    await EmailJSNodeJS.send(
      process.env.EMAILJS_SERVICE_ID,
      process.env.EMAILJS_OTP_TEMPLATE_ID,
      templateParams,
    );

    return {
      statusCode: 200,
      body: JSON.stringify({
        message: resend
          ? "New verification code sent successfully."
          : "Registration successful. Verification email sent.",
        email: email,
      }),
    };
  } catch (error) {
    console.error("Error processing registration:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Error processing your request.",
        error: error.message,
      }),
    };
  }
};
