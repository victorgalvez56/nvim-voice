"use client";

import { motion } from "framer-motion";

const techs = [
  "Swift 5.9+",
  "macOS 14+",
  "SwiftUI",
  "WhisperKit",
  "GPT-4 Vision",
  "ScreenCaptureKit",
  "CryptoKit",
];

export default function TechStack() {
  return (
    <section className="px-6 py-16">
      <div className="max-w-4xl mx-auto">
        <motion.h2
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.4 }}
          className="text-2xl font-bold text-center mb-8"
        >
          Built With
        </motion.h2>
        <motion.div
          initial={{ opacity: 0 }}
          whileInView={{ opacity: 1 }}
          viewport={{ once: true }}
          transition={{ duration: 0.4 }}
          className="flex flex-wrap justify-center gap-3"
        >
          {techs.map((tech) => (
            <span
              key={tech}
              className="glass rounded-full px-4 py-2 text-sm text-zinc-300 font-medium"
            >
              {tech}
            </span>
          ))}
        </motion.div>
      </div>
    </section>
  );
}
