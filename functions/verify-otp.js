const { findUserByEmail, updateApplication } = require("./googleSheetClient");

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
    const { email, otp } = JSON.parse(event.body);

    if (!email || !otp) {
      return {
        statusCode: 400,
        body: JSON.stringify({ message: "Email and OTP are required." }),
      };
    }

    // Find the user in Google Sheets
    const user = await findUserByEmail(email);

    if (!user) {
      return {
        statusCode: 404,
        body: JSON.stringify({ message: "User not found." }),
      };
    }

    // Check if OTP has expired
    const expiresAt = user.expiresAt ? parseInt(user.expiresAt) : null;
    if (expiresAt && Date.now() > expiresAt) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: "Verification code has expired. Please request a new one.",
        }),
      };
    }

    // Verify the OTP matches what's stored in Google Sheets
    if (user.otp === otp) {
      // Update user status to verified
      const rowIndex = user._rowNumber - 2; // Adjust for 0-indexing and header row
      await updateApplication(rowIndex, {
        status: "verified",
        expiresAt: null, // Clear expiry time after successful verification
      });

      return {
        statusCode: 200,
        body: JSON.stringify({
          message: "Email verified successfully.",
          email: email,
          verified: true,
        }),
      };
    } else {
      return {
        statusCode: 400,
        body: JSON.stringify({ message: "Invalid verification code." }),
      };
    }
  } catch (error) {
    console.error("Error verifying OTP:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Error verifying code.",
        error: error.message,
      }),
    };
  }
};
