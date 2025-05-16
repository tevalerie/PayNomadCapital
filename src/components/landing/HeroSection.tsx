import React from "react";

const HeroSection = () => {
  return (
    <section className="relative h-screen flex items-center justify-center overflow-hidden">
      <div
        className="absolute inset-0 bg-gradient-to-r from-[#2c3e50] to-[#0077be] animate-gradient-x"
        style={{
          backgroundSize: "200% 200%",
          animation: "gradient 15s ease infinite",
        }}
      />
      <div className="relative z-10 text-center px-4">
        <h1 className="text-5xl md:text-7xl font-bold text-white mb-4">
          PayNomad Capital
        </h1>
        <p className="text-xl md:text-2xl text-white/90 max-w-2xl mx-auto">
          Empowering Your Finances
        </p>
      </div>
    </section>
  );
};

export default HeroSection;
