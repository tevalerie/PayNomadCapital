import React from "react";
import ServiceCard from "./ServiceCard";
import { Coins, RefreshCw, ArrowRightLeft, Wallet } from "lucide-react";

const ServicesSection = () => {
  const services = [
    {
      title: "Cryptocurrency",
      description:
        "Secure cryptocurrency trading, storage, and exchange services with competitive rates and advanced security protocols.",
      icon: <Coins />,
    },
    {
      title: "Currency Exchange",
      description:
        "Competitive exchange rates for over 50 currencies with minimal fees and fast processing times for global transactions.",
      icon: <ArrowRightLeft />,
    },
    {
      title: "Remittance Services",
      description:
        "Quick and reliable international money transfers to over 100 countries with transparent fee structures.",
      icon: <RefreshCw />,
    },
    {
      title: "Money Services",
      description:
        "Comprehensive financial solutions including bill payments, prepaid cards, and digital wallet services.",
      icon: <Wallet />,
    },
  ];

  return (
    <section id="services" className="py-20 bg-gray-50">
      <div className="container mx-auto px-4">
        <h2 className="text-4xl font-bold text-center mb-12 text-[#2c3e50]">
          Our Services
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {services.map((service, index) => (
            <ServiceCard
              key={index}
              title={service.title}
              description={service.description}
              icon={service.icon}
            />
          ))}
        </div>
      </div>
    </section>
  );
};

export default ServicesSection;
