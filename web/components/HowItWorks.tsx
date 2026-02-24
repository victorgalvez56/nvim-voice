"use client";

import { motion } from "framer-motion";

const steps = [
  {
    number: "1",
    title: "Press Cmd+Shift+V",
    description: "Activate the global hotkey to start recording.",
    visual: (
      <div className="flex gap-1">
        {["Cmd", "Shift", "V"].map((key) => (
          <span
            key={key}
            className="inline-flex items-center justify-center px-2.5 py-1.5 rounded-lg bg-zinc-800 border border-zinc-700 text-xs font-mono font-medium text-zinc-300 shadow-[0_2px_0_rgba(0,0,0,0.3)]"
          >
            {key}
          </span>
        ))}
      </div>
    ),
  },
  {
    number: "2",
    title: "Speak your intent",
    description:
      'Say what you want to do, like "find files in this project" or "delete this line".',
    visual: (
      <div className="glass rounded-xl px-4 py-2 text-sm text-zinc-300 italic">
        &quot;find files in this project&quot;
      </div>
    ),
  },
  {
    number: "3",
    title: "AI analyzes context",
    description:
      "Whisper transcribes locally. GPT-4 Vision reads your screen and keybindings.",
    visual: (
      <div className="flex items-center gap-2 text-xs text-zinc-400">
        <span className="glass rounded-lg px-2 py-1">Whisper</span>
        <span className="text-brand-purple">+</span>
        <span className="glass rounded-lg px-2 py-1">GPT-4V</span>
        <span className="text-brand-purple">+</span>
        <span className="glass rounded-lg px-2 py-1">Screenshot</span>
      </div>
    ),
  },
  {
    number: "4",
    title: "See the result",
    description:
      "A floating overlay shows the key sequence, explanation, and step-by-step guide.",
    visual: (
      <div className="glass rounded-xl px-4 py-2">
        <span className="font-mono font-bold text-brand-green text-sm">
          &lt;leader&gt;ff
        </span>
      </div>
    ),
  },
];

export default function HowItWorks() {
  return (
    <section className="px-6 py-20 md:py-28">
      <div className="max-w-2xl mx-auto">
        <motion.h2
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.4 }}
          className="text-3xl md:text-4xl font-bold text-center mb-14"
        >
          How It Works
        </motion.h2>
        <div className="relative">
          <div className="absolute left-6 top-8 bottom-8 w-px border-l border-dashed border-zinc-700" />
          <div className="space-y-10">
            {steps.map((step, i) => (
              <motion.div
                key={step.number}
                initial={{ opacity: 0, x: -20 }}
                whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.4, delay: i * 0.1 }}
                className="relative flex gap-5 pl-0"
              >
                <div className="relative z-10 flex-shrink-0 w-12 h-12 rounded-full bg-brand-purple/20 border border-brand-purple/30 flex items-center justify-center text-brand-purple font-bold text-lg">
                  {step.number}
                </div>
                <div className="pt-1">
                  <h3 className="text-lg font-semibold mb-1">{step.title}</h3>
                  <p className="text-sm text-zinc-400 mb-3">
                    {step.description}
                  </p>
                  {step.visual}
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
