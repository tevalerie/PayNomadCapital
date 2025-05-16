import React from "react";
import { motion } from "framer-motion";

interface ServiceCardProps {
  title: string;
  description: string;
  icon: React.ReactNode;
}

const ServiceCard: React.FC<ServiceCardProps> = ({
  title,
  description,
  icon,
}) => {
  return (
    <motion.div
      className="bg-white rounded-lg shadow-lg p-6 h-full flex flex-col transition-all duration-300 hover:shadow-xl border border-gray-100"
      whileHover={{ y: -5 }}
      initial={{ opacity: 0, y: 20 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true }}
      transition={{ duration: 0.5 }}
    >
      <div className="text-[#0077be] mb-4 text-4xl">{icon}</div>
      <h3 className="text-xl font-bold mb-3 text-[#2c3e50]">{title}</h3>
      <p className="text-gray-600 flex-grow">{description}</p>
      <div className="mt-4 pt-2 border-t border-gray-100">
        <button className="text-[#0077be] font-medium hover:text-[#2c3e50] transition-colors">
          Learn more →
        </button>
      </div>
    </motion.div>
  );
};

export default ServiceCard;
