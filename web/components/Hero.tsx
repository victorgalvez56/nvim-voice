"use client";

import Image from "next/image";
import { motion } from "framer-motion";
import DynamicIslandMockup from "./DynamicIslandMockup";

export default function Hero() {
  return (
    <section className="relative flex flex-col items-center text-center px-6 pt-24 pb-16 md:pt-32 md:pb-24">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        className="flex flex-col items-center"
      >
        <Image
          src="/logo.png"
          alt="NvimVoice logo"
          width={80}
          height={80}
          className="mb-6 rounded-2xl"
          priority
        />
        <h1 className="text-4xl md:text-6xl font-bold tracking-tight mb-4 bg-gradient-to-r from-white via-zinc-200 to-zinc-400 bg-clip-text text-transparent">
          Control Neovim
          <br />
          with Your Voice
        </h1>
        <p className="text-lg md:text-xl text-zinc-400 max-w-xl mb-8">
          Speak your intent, see the exact keystrokes. Local Whisper
          transcription, GPT-4 Vision context, and a floating overlay that shows
          you what to press.
        </p>
        <div className="flex flex-col sm:flex-row gap-3 mb-16">
          <a
            href="/NvimVoice.dmg"
            download
            className="inline-flex items-center justify-center h-12 px-6 rounded-full bg-brand-purple text-white font-medium hover:bg-brand-purple/90 transition-colors"
          >
            Download .dmg
          </a>
          <a
            href="https://github.com/victorgalvez56/nvim-voice"
            className="inline-flex items-center justify-center h-12 px-6 rounded-full border border-zinc-700 text-zinc-300 font-medium hover:bg-zinc-800/50 transition-colors"
          >
            View on GitHub
          </a>
        </div>
      </motion.div>
      <motion.div
        initial={{ opacity: 0, y: 30 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5, delay: 0.3 }}
        className="w-full max-w-xl"
      >
        <DynamicIslandMockup />
      </motion.div>
    </section>
  );
}
