import React, { useState } from "react";
import { Button } from "./ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";

const TestConnection = () => {
  const [result, setResult] = useState<string>("");
  const [error, setError] = useState<string>("");
  const [isLoading, setIsLoading] = useState(false);

  const testConnection = async () => {
    setIsLoading(true);
    setResult("");
    setError("");

    try {
      // Simple API test - replace with your actual API endpoint
      const response = await fetch(
        "https://jsonplaceholder.typicode.com/todos/1",
      );

      if (!response.ok) {
        throw new Error(`API error: ${response.status}`);
      }

      const data = await response.json();
      console.log("Connection test result:", data);
      setResult(JSON.stringify(data, null, 2));
    } catch (err) {
      console.error(`Connection test failed:`, err);
      setError(err instanceof Error ? err.message : String(err));
    } finally {
      setIsLoading(false);
    }
  };

  const testEmailService = async () => {
    setIsLoading(true);
    setResult("");
    setError("");

    try {
      // This is a placeholder - replace with your actual email service test
      // For example, you might have an API endpoint that sends a test email
      console.log("Testing email service...");

      // Simulate API call
      setTimeout(() => {
        setResult(
          JSON.stringify(
            {
              success: true,
              message: "Email service is working correctly",
            },
            null,
            2,
          ),
        );
        setIsLoading(false);
      }, 1500);
    } catch (err) {
      console.error(`Email service test failed:`, err);
      setError(err instanceof Error ? err.message : String(err));
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-[#faf4eb] p-8">
      <Card className="max-w-2xl mx-auto">
        <CardHeader>
          <CardTitle>API Connection Test</CardTitle>
        </CardHeader>
        <CardContent className="space-y-6">
          <div className="space-y-4">
            <div className="flex space-x-4">
              <Button
                onClick={testConnection}
                disabled={isLoading}
                className="bg-[#0077be] hover:bg-[#0066a6]"
              >
                {isLoading ? "Testing..." : "Test API Connection"}
              </Button>
              <Button
                onClick={testEmailService}
                disabled={isLoading}
                className="bg-[#2c3e50] hover:bg-[#1a2530]"
              >
                {isLoading ? "Testing..." : "Test Email Service"}
              </Button>
            </div>

            <div className="mt-4">
              <h3 className="font-medium mb-2">Environment Status:</h3>
              <div className="bg-gray-100 p-3 rounded text-sm">
                <p>API Connection: Ready to test</p>
                <p>Email Service: Ready to test</p>
              </div>
            </div>

            {error && (
              <div className="p-4 bg-red-50 border border-red-200 text-red-700 rounded">
                <h3 className="font-medium mb-2">Error:</h3>
                <pre className="whitespace-pre-wrap text-sm">{error}</pre>
              </div>
            )}

            {result && (
              <div className="p-4 bg-green-50 border border-green-200 text-green-700 rounded">
                <h3 className="font-medium mb-2">Result:</h3>
                <pre className="whitespace-pre-wrap text-sm">{result}</pre>
              </div>
            )}
          </div>
        </CardContent>
      </Card>
    </div>
  );
};

export default TestConnection;
