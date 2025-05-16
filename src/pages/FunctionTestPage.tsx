import React from "react";
import FunctionTester from "../components/FunctionTester";

const FunctionTestPage = () => {
  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4">
      <div className="max-w-3xl mx-auto">
        <h1 className="text-2xl font-bold text-center mb-8">
          Netlify Function Test
        </h1>
        <FunctionTester />
      </div>
    </div>
  );
};

export default FunctionTestPage;
