import React, { useState } from "react";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { CheckCircle, XCircle, Loader2 } from "lucide-react";

const EmailVerificationFlow = () => {
  const [email, setEmail] = useState("");
  const [otp, setOtp] = useState("");
  const [step, setStep] = useState<"email" | "otp" | "success" | "error">(
    "email",
  );
  const [isLoading, setIsLoading] = useState(false);
  const [message, setMessage] = useState("");

  const handleEmailSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      setMessage("Please enter a valid email address");
      return;
    }

    setIsLoading(true);
    setMessage("");

    try {
      // Generate OTP
      const generatedOtp = Math.floor(
        100000 + Math.random() * 900000,
      ).toString();

      // In a real app, you would send this to the server
      console.log(`Generated OTP for ${email}: ${generatedOtp}`);

      // Simulate API call
      await new Promise((resolve) => setTimeout(resolve, 1500));

      // Store OTP in session storage for demo purposes
      sessionStorage.setItem("demoOtp", generatedOtp);
      sessionStorage.setItem("demoEmail", email);

      setStep("otp");
      setMessage("Verification code sent to your email");
    } catch (error) {
      console.error("Error sending verification code:", error);
      setMessage("Failed to send verification code. Please try again.");
    } finally {
      setIsLoading(false);
    }
  };

  const handleOtpSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!otp || otp.length !== 6) {
      setMessage("Please enter a valid 6-digit verification code");
      return;
    }

    setIsLoading(true);
    setMessage("");

    try {
      // In a real app, you would verify this with the server
      const storedOtp = sessionStorage.getItem("demoOtp");

      // Simulate API call
      await new Promise((resolve) => setTimeout(resolve, 1500));

      if (otp === storedOtp) {
        setStep("success");
        setMessage("Email verified successfully!");
        // Clear the OTP from storage
        sessionStorage.removeItem("demoOtp");
      } else {
        setStep("error");
        setMessage("Invalid verification code. Please try again.");
      }
    } catch (error) {
      console.error("Error verifying code:", error);
      setMessage("Failed to verify code. Please try again.");
      setStep("error");
    } finally {
      setIsLoading(false);
    }
  };

  const handleResendOtp = async () => {
    setIsLoading(true);
    setMessage("");

    try {
      // Generate new OTP
      const newOtp = Math.floor(100000 + Math.random() * 900000).toString();

      // In a real app, you would send this to the server
      console.log(`Resent OTP for ${email}: ${newOtp}`);

      // Simulate API call
      await new Promise((resolve) => setTimeout(resolve, 1500));

      // Store new OTP
      sessionStorage.setItem("demoOtp", newOtp);

      setMessage("New verification code sent to your email");
    } catch (error) {
      console.error("Error resending verification code:", error);
      setMessage("Failed to resend verification code. Please try again.");
    } finally {
      setIsLoading(false);
    }
  };

  const resetFlow = () => {
    setEmail("");
    setOtp("");
    setStep("email");
    setMessage("");
  };

  return (
    <div className="flex items-center justify-center min-h-screen bg-[#faf4eb] p-4">
      <Card className="w-full max-w-md bg-white shadow-lg">
        <CardHeader className="text-center">
          <CardTitle className="text-2xl font-bold text-[#2c3e50]">
            {step === "email" && "Verify Your Email"}
            {step === "otp" && "Enter Verification Code"}
            {step === "success" && "Verification Successful"}
            {step === "error" && "Verification Failed"}
          </CardTitle>
        </CardHeader>
        <CardContent>
          {message && (
            <div
              className={`mb-4 p-3 rounded ${step === "success" ? "bg-green-100 text-green-800" : step === "error" ? "bg-red-100 text-red-800" : "bg-blue-100 text-blue-800"}`}
            >
              {message}
            </div>
          )}

          {step === "email" && (
            <form onSubmit={handleEmailSubmit} className="space-y-4">
              <div className="space-y-2">
                <label
                  htmlFor="email"
                  className="block text-sm font-medium text-gray-700"
                >
                  Email Address
                </label>
                <Input
                  id="email"
                  type="email"
                  placeholder="Enter your email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  disabled={isLoading}
                  className="w-full"
                />
              </div>
              <Button
                type="submit"
                className="w-full bg-[#0077be] hover:bg-[#0066a6]"
                disabled={isLoading}
              >
                {isLoading ? (
                  <>
                    <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                    Sending...
                  </>
                ) : (
                  "Send Verification Code"
                )}
              </Button>
            </form>
          )}

          {step === "otp" && (
            <form onSubmit={handleOtpSubmit} className="space-y-4">
              <div className="space-y-2">
                <label
                  htmlFor="otp"
                  className="block text-sm font-medium text-gray-700"
                >
                  Verification Code
                </label>
                <Input
                  id="otp"
                  type="text"
                  placeholder="Enter 6-digit code"
                  value={otp}
                  onChange={(e) => setOtp(e.target.value)}
                  maxLength={6}
                  disabled={isLoading}
                  className="w-full text-center text-lg tracking-widest"
                />
              </div>
              <Button
                type="submit"
                className="w-full bg-[#0077be] hover:bg-[#0066a6]"
                disabled={isLoading}
              >
                {isLoading ? (
                  <>
                    <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                    Verifying...
                  </>
                ) : (
                  "Verify Code"
                )}
              </Button>
              <div className="flex justify-between items-center pt-2">
                <Button
                  type="button"
                  variant="link"
                  onClick={resetFlow}
                  className="text-[#0077be] p-0"
                >
                  Change Email
                </Button>
                <Button
                  type="button"
                  variant="link"
                  onClick={handleResendOtp}
                  disabled={isLoading}
                  className="text-[#0077be] p-0"
                >
                  Resend Code
                </Button>
              </div>
            </form>
          )}

          {step === "success" && (
            <div className="text-center space-y-4">
              <div className="flex justify-center">
                <CheckCircle className="h-16 w-16 text-green-500" />
              </div>
              <p className="text-gray-700">
                Your email has been successfully verified.
              </p>
              <Button
                onClick={resetFlow}
                className="bg-[#0077be] hover:bg-[#0066a6]"
              >
                Start Over
              </Button>
            </div>
          )}

          {step === "error" && (
            <div className="text-center space-y-4">
              <div className="flex justify-center">
                <XCircle className="h-16 w-16 text-red-500" />
              </div>
              <p className="text-gray-700">
                Verification failed. Please try again.
              </p>
              <div className="flex space-x-2">
                <Button
                  onClick={() => setStep("otp")}
                  className="flex-1 bg-[#0077be] hover:bg-[#0066a6]"
                >
                  Try Again
                </Button>
                <Button
                  onClick={resetFlow}
                  variant="outline"
                  className="flex-1"
                >
                  Start Over
                </Button>
              </div>
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
};

export default EmailVerificationFlow;
