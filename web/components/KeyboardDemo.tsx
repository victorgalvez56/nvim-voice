"use client";

import { motion } from "framer-motion";
import { Mic } from "lucide-react";
import MoonlanderKeyboard from "./MoonlanderKeyboard";

export default function KeyboardDemo() {
  return (
    <section className="px-6 py-20 md:py-28">
      <div className="max-w-6xl mx-auto">
        {/* Heading */}
        <motion.h2
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.4 }}
          className="text-3xl md:text-4xl font-bold text-center mb-4"
        >
          Physical Key Awareness
        </motion.h2>
        <motion.p
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.4, delay: 0.08 }}
          className="text-zinc-400 text-center mb-10 max-w-xl mx-auto"
        >
          NvimVoice knows your keyboard layout. See exactly which keys to press.
        </motion.p>

        {/* Voice command → key sequence */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.4, delay: 0.16 }}
          className="glass rounded-2xl p-5 mb-8 max-w-lg mx-auto"
        >
          <div className="flex items-center gap-3 mb-3">
            <Mic className="w-4 h-4 text-brand-purple shrink-0" />
            <span className="text-sm text-zinc-300 italic">
              &ldquo;find files in this project&rdquo;
            </span>
          </div>
          <span className="inline-flex items-center font-mono font-bold text-sm text-brand-green bg-brand-green/10 px-3 py-1 rounded-md border border-brand-green/20">
            &lt;leader&gt;ff
          </span>
        </motion.div>

        {/* Keyboard visualization */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.4, delay: 0.24 }}
          className="glass rounded-2xl p-6 md:p-8"
        >
          <MoonlanderKeyboard />
        </motion.div>

        {/* Keyboard model tabs + Keymapp note */}
        <motion.div
          initial={{ opacity: 0 }}
          whileInView={{ opacity: 1 }}
          viewport={{ once: true }}
          transition={{ duration: 0.4, delay: 0.32 }}
          className="flex flex-col items-center mt-6"
        >
          <div className="flex flex-wrap justify-center gap-2">
            <span className="px-3 py-1.5 text-xs font-medium rounded-full bg-brand-purple/20 text-brand-purple border border-brand-purple/30">
              Moonlander
            </span>
            <span className="px-3 py-1.5 text-xs font-medium rounded-full text-zinc-600 border border-zinc-800 cursor-not-allowed">
              Voyager
            </span>
            <span className="px-3 py-1.5 text-xs font-medium rounded-full text-zinc-600 border border-zinc-800 cursor-not-allowed">
              ErgoDox EZ
            </span>
            <span className="px-3 py-1.5 text-xs font-medium rounded-full text-zinc-600 border border-zinc-800 cursor-not-allowed">
              Lily58
            </span>
          </div>
          <p className="text-xs text-zinc-500 mt-3">
            Connects to Keymapp for real-time layout sync
          </p>
        </motion.div>
      </div>
    </section>
  );
}
