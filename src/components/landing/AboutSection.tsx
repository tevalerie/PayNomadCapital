import React from "react";

const AboutSection = () => {
  return (
    <section id="about" className="py-20 bg-white">
      <div className="container mx-auto px-4">
        <h2 className="text-4xl font-bold text-center mb-12 text-[#2c3e50]">
          About Us
        </h2>
        <div className="max-w-4xl mx-auto">
          <p className="text-lg text-gray-700 mb-6 leading-relaxed">
            PayNomad Capital is a premier financial services provider
            specializing in innovative solutions for the modern global citizen.
            With a focus on security, efficiency, and accessibility, we offer a
            comprehensive suite of financial services designed to meet the needs
            of individuals and businesses alike.
          </p>
          <p className="text-lg text-gray-700 mb-6 leading-relaxed">
            Founded on the principles of trust, transparency, and technological
            excellence, our team of financial experts is dedicated to empowering
            your financial journey with cutting-edge solutions that transcend
            borders and traditional banking limitations.
          </p>
          <div className="flex justify-center mt-10">
            <div className="grid grid-cols-2 md:grid-cols-4 gap-8 text-center">
              <div>
                <div className="text-[#0077be] font-bold text-4xl">10+</div>
                <div className="text-gray-600">Years Experience</div>
              </div>
              <div>
                <div className="text-[#0077be] font-bold text-4xl">50+</div>
                <div className="text-gray-600">Countries Served</div>
              </div>
              <div>
                <div className="text-[#0077be] font-bold text-4xl">100K+</div>
                <div className="text-gray-600">Happy Clients</div>
              </div>
              <div>
                <div className="text-[#0077be] font-bold text-4xl">99.9%</div>
                <div className="text-gray-600">Service Uptime</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default AboutSection;
