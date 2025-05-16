import React, { useState } from "react";
import BlogCard from "./BlogCard";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "../ui/dialog";

const InsightsSection = () => {
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [activeArticle, setActiveArticle] = useState({
    title: "",
    content: "",
  });

  const articles = [
    {
      title: "The Future of Digital Banking",
      excerpt:
        "Explore how emerging technologies are reshaping the banking landscape and what it means for consumers.",
      date: "June 15, 2023",
      category: "Technology",
      image:
        "https://images.unsplash.com/photo-1563986768609-322da13575f3?w=800&q=80",
      content:
        "The banking industry is undergoing a profound transformation driven by technological innovation. From blockchain to artificial intelligence, new technologies are changing how financial services are delivered and consumed. This article explores the key trends shaping the future of digital banking and their implications for consumers and financial institutions alike.",
    },
    {
      title: "Cryptocurrency Investment Strategies",
      excerpt:
        "Learn about effective approaches to cryptocurrency investing in today's volatile market conditions.",
      date: "May 22, 2023",
      category: "Investment",
      image:
        "https://images.unsplash.com/photo-1518546305927-5a555bb7020d?w=800&q=80",
      content:
        "Cryptocurrency markets present unique opportunities and challenges for investors. This article outlines several strategies for navigating the volatile crypto landscape, including dollar-cost averaging, portfolio diversification, and risk management techniques. Whether you're a beginner or experienced investor, these approaches can help you build a more resilient cryptocurrency investment strategy.",
    },
    {
      title: "Global Remittance Trends in 2023",
      excerpt:
        "Discover how international money transfer services are evolving to meet changing consumer needs.",
      date: "April 10, 2023",
      category: "Finance",
      image:
        "https://images.unsplash.com/photo-1616803689943-5601631c7fec?w=800&q=80",
      content:
        "The global remittance industry continues to grow as migration patterns evolve and digital solutions make cross-border transfers more accessible. This article examines the latest trends in international money transfers, including the impact of digital currencies, mobile payment platforms, and regulatory changes on the remittance landscape.",
    },
  ];

  const handleExpandArticle = (content: string, title: string) => {
    setActiveArticle({ title, content });
    setIsModalOpen(true);
  };

  return (
    <section id="insights" className="py-20 bg-white">
      <div className="container mx-auto px-4">
        <h2 className="text-4xl font-bold text-center mb-12 text-[#2c3e50]">
          Financial Insights
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {articles.map((article, index) => (
            <BlogCard
              key={index}
              title={article.title}
              excerpt={article.excerpt}
              date={article.date}
              category={article.category}
              image={article.image}
              content={article.content}
              onExpand={handleExpandArticle}
            />
          ))}
        </div>

        <Dialog open={isModalOpen} onOpenChange={setIsModalOpen}>
          <DialogContent className="sm:max-w-2xl">
            <DialogHeader>
              <DialogTitle className="text-2xl font-bold text-[#2c3e50]">
                {activeArticle.title}
              </DialogTitle>
            </DialogHeader>
            <div className="mt-4">
              <p className="text-gray-700 leading-relaxed">
                {activeArticle.content}
              </p>
              <div className="mt-8 pt-4 border-t border-gray-200">
                <p className="text-gray-500 italic">
                  Published by PayNomad Capital Research Team
                </p>
              </div>
            </div>
          </DialogContent>
        </Dialog>
      </div>
    </section>
  );
};

export default InsightsSection;
