import React, { useState } from "react";
import { Button } from "./ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";

const FunctionTester = () => {
  const [results, setResults] = useState<Record<string, string>>({});
  const [isLoading, setIsLoading] = useState(false);

  const testEndpoints = async () => {
    setIsLoading(true);
    const newResults: Record<string, string> = {};

    const endpoints = [
      "/.netlify/functions/submit-application",
      "/.netlify/functions/verify-otp",
      "/api/submit-application",
      "/api/verify-otp",
    ];

    for (const endpoint of endpoints) {
      try {
        const response = await fetch(endpoint, {
          method: "OPTIONS",
          headers: {
            "Content-Type": "application/json",
          },
        });

        newResults[endpoint] =
          `Status: ${response.status} ${response.statusText}`;
      } catch (error) {
        newResults[endpoint] =
          `Error: ${error instanceof Error ? error.message : String(error)}`;
      }
    }

    setResults(newResults);
    setIsLoading(false);
  };

  return (
    <Card className="w-full max-w-3xl mx-auto">
      <CardHeader>
        <CardTitle>Function URL Tester</CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <Button
          onClick={testEndpoints}
          disabled={isLoading}
          className="bg-[#0077be] hover:bg-[#0066a6]"
        >
          {isLoading ? "Testing..." : "Test Function URLs"}
        </Button>

        {Object.keys(results).length > 0 && (
          <div className="mt-4 space-y-2">
            <h3 className="text-lg font-medium">Results:</h3>
            {Object.entries(results).map(([endpoint, result]) => (
              <div key={endpoint} className="p-3 border rounded-md">
                <p className="font-medium">{endpoint}</p>
                <p
                  className={
                    result.includes("Error")
                      ? "text-red-500"
                      : result.includes("Status: 404")
                        ? "text-red-500"
                        : result.includes("Status: 405")
                          ? "text-green-500"
                          : "text-blue-500"
                  }
                >
                  {result}
                </p>
              </div>
            ))}
          </div>
        )}

        <div className="mt-6 p-4 bg-gray-50 rounded-md">
          <h3 className="text-lg font-medium mb-2">Interpretation Guide:</h3>
          <ul className="list-disc pl-5 space-y-1">
            <li>
              <span className="text-green-500 font-medium">Status: 405</span> -
              Good! Function exists but doesn't allow OPTIONS/GET (expected)
            </li>
            <li>
              <span className="text-red-500 font-medium">Status: 404</span> -
              Function not found at this path
            </li>
            <li>
              <span className="text-red-500 font-medium">Error</span> - Network
              or other error occurred
            </li>
          </ul>
        </div>
      </CardContent>
    </Card>
  );
};

export default FunctionTester;
