"use client";

import { motion } from "framer-motion";
import { Download, Mic, Monitor, Accessibility } from "lucide-react";

export default function DownloadCTA() {
  return (
    <section className="px-6 py-20 md:py-28">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ duration: 0.4 }}
        className="max-w-lg mx-auto text-center"
      >
        <h2 className="text-3xl md:text-4xl font-bold mb-4">Get Started</h2>
        <p className="text-zinc-400 mb-8">
          macOS 14.0+ required. Free and open source.
        </p>
        <a
          href="/NvimVoice.dmg"
          download
          className="inline-flex items-center justify-center gap-2 h-14 px-8 rounded-full bg-brand-purple text-white font-semibold text-lg hover:bg-brand-purple/90 transition-colors mb-4"
        >
          <Download className="w-5 h-5" />
          Download .dmg
        </a>
        <p className="text-sm text-zinc-500 mb-10">
          or{" "}
          <a
            href="https://github.com/victorgalvez56/nvim-voice#installation"
            className="text-brand-purple hover:underline"
          >
            build from source
          </a>
        </p>
        <div className="glass rounded-2xl p-6 text-left">
          <h3 className="text-sm font-semibold text-zinc-300 mb-4">
            Required Permissions
          </h3>
          <div className="space-y-3">
            {[
              {
                icon: Mic,
                label: "Microphone",
                desc: "To record voice commands",
              },
              {
                icon: Monitor,
                label: "Screen Recording",
                desc: "To capture visual context",
              },
              {
                icon: Accessibility,
                label: "Accessibility",
                desc: "For the global hotkey",
              },
            ].map((perm) => (
              <div key={perm.label} className="flex items-center gap-3">
                <perm.icon className="w-4 h-4 text-brand-purple flex-shrink-0" />
                <div>
                  <span className="text-sm font-medium text-zinc-200">
                    {perm.label}
                  </span>
                  <span className="text-sm text-zinc-500"> — {perm.desc}</span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </motion.div>
    </section>
  );
}
