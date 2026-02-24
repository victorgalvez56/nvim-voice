"use client";

import { motion } from "framer-motion";
import {
  Mic,
  Shield,
  Eye,
  Layers,
  Keyboard,
  Terminal,
} from "lucide-react";

const features = [
  {
    icon: Mic,
    title: "Voice to Keybindings",
    description:
      "Press Cmd+Shift+V, speak what you want to do, and get the exact Vim keystrokes.",
  },
  {
    icon: Shield,
    title: "Local Transcription",
    description:
      "Whisper runs locally via WhisperKit. No audio ever leaves your machine.",
  },
  {
    icon: Eye,
    title: "Visual Context",
    description:
      "GPT-4 Vision analyzes your screen to understand your editor state and context.",
  },
  {
    icon: Layers,
    title: "Dynamic Island Overlay",
    description:
      "A floating pill shows the key sequence, step-by-step instructions, and alternatives.",
  },
  {
    icon: Keyboard,
    title: "ZSA Keyboard Support",
    description:
      "Physical key positions for Moonlander, Voyager, and ErgoDox EZ via Keymapp.",
  },
  {
    icon: Terminal,
    title: "LazyVim Aware",
    description:
      "Parses your Neovim config and merges it with LazyVim defaults for accurate results.",
  },
];

export default function Features() {
  return (
    <section className="px-6 py-20 md:py-28">
      <div className="max-w-6xl mx-auto">
        <motion.h2
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.4 }}
          className="text-3xl md:text-4xl font-bold text-center mb-14"
        >
          Features
        </motion.h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
          {features.map((feature, i) => (
            <motion.div
              key={feature.title}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.4, delay: i * 0.08 }}
              className="glass rounded-2xl p-6 hover:border-brand-purple/20 transition-colors"
            >
              <feature.icon className="w-8 h-8 text-brand-purple mb-4" />
              <h3 className="text-lg font-semibold mb-2">{feature.title}</h3>
              <p className="text-sm text-zinc-400 leading-relaxed">
                {feature.description}
              </p>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
}
