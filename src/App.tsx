import React from "react";
import { Routes, Route, useRoutes } from "react-router-dom";
import Home from "./components/home";
import SignupPage from "./pages/SignupPage";
import OtpVerificationPage from "./pages/OtpVerificationPage";
import ErrorBoundary from "./components/ErrorBoundary";
import LandingPage from "./components/landing/LandingPage";
import routes from "tempo-routes";

function App() {
  console.log("App rendering, Home component available:", !!Home);

  // Use the routes with useRoutes hook when in Tempo environment
  const tempoRoutes =
    import.meta.env.VITE_TEMPO === "true" ? useRoutes(routes) : null;

  return (
    <ErrorBoundary>
      {tempoRoutes}
      <Routes>
        <Route path="/" element={<LandingPage />} />
        <Route
          path="/home"
          element={
            <div className="bg-white min-h-screen">
              <Home />
            </div>
          }
        />
        <Route path="/newsignup" element={<SignupPage />} />
        <Route path="/OTPVerification" element={<OtpVerificationPage />} />

        {/* Add this before any catchall route */}
        {import.meta.env.VITE_TEMPO === "true" && <Route path="/tempobook/*" />}
      </Routes>
    </ErrorBoundary>
  );
}

export default App;
