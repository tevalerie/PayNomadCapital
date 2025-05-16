import React from "react";
import Navbar from "./Navbar";
import HeroSection from "./HeroSection";
import AboutSection from "./AboutSection";
import ServicesSection from "./ServicesSection";
import InsightsSection from "./InsightsSection";
import ContactSection from "./ContactSection";
import Footer from "./Footer";

const LandingPage = () => {
  return (
    <div className="bg-white min-h-screen">
      <Navbar />
      <HeroSection />
      <AboutSection />
      <ServicesSection />
      <InsightsSection />
      <ContactSection />
      <Footer />
    </div>
  );
};

export default LandingPage;
