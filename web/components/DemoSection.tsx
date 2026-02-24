"use client";

import Image from "next/image";
import { motion } from "framer-motion";

export default function DemoSection() {
  return (
    <section className="px-6 py-20 md:py-28">
      <div className="max-w-5xl mx-auto">
        <motion.h2
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.4 }}
          className="text-3xl md:text-4xl font-bold text-center mb-4"
        >
          See It in Action
        </motion.h2>
        <motion.p
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.4, delay: 0.08 }}
          className="text-zinc-400 text-center mb-10 max-w-xl mx-auto"
        >
          Speak a command, get the keystrokes, see them executed — all in one
          flow.
        </motion.p>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.4, delay: 0.16 }}
          className="glass rounded-2xl p-2 md:p-3 overflow-hidden"
        >
          <Image
            src="/demo.gif"
            alt="NvimVoice demo — voice command to Neovim keystrokes"
            width={1400}
            height={840}
            className="w-full h-auto rounded-xl"
            unoptimized
          />
        </motion.div>
      </div>
    </section>
  );
}
