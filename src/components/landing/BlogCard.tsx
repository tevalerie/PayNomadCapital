import React, { useState } from "react";
import { motion } from "framer-motion";

interface BlogCardProps {
  title: string;
  excerpt: string;
  date: string;
  category: string;
  image: string;
  content: string;
  onExpand: (content: string, title: string) => void;
}

const BlogCard: React.FC<BlogCardProps> = ({
  title,
  excerpt,
  date,
  category,
  image,
  content,
  onExpand,
}) => {
  return (
    <motion.div
      className="bg-white rounded-lg shadow-md overflow-hidden h-full flex flex-col"
      whileHover={{ y: -5 }}
      initial={{ opacity: 0, y: 20 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true }}
      transition={{ duration: 0.5 }}
    >
      <div
        className="h-48 bg-cover bg-center"
        style={{ backgroundImage: `url(${image})` }}
      />
      <div className="p-6 flex flex-col flex-grow">
        <div className="flex justify-between items-center mb-2 text-sm text-gray-500">
          <span>{date}</span>
          <span className="bg-blue-100 text-[#0077be] px-2 py-1 rounded">
            {category}
          </span>
        </div>
        <h3 className="text-xl font-bold mb-2 text-[#2c3e50]">{title}</h3>
        <p className="text-gray-600 mb-4 flex-grow">{excerpt}</p>
        <button
          onClick={() => onExpand(content, title)}
          className="text-[#0077be] font-medium hover:text-[#2c3e50] transition-colors"
        >
          Read more →
        </button>
      </div>
    </motion.div>
  );
};

export default BlogCard;
