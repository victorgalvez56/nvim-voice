"use client";

import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";

type Phase = "recording" | "processing" | "expanded" | "collapsing";

const CYCLE_TIMINGS: Record<Phase, number> = {
  recording: 2000,
  processing: 1500,
  expanded: 3500,
  collapsing: 600,
};

const spring = { type: "spring" as const, duration: 0.4, bounce: 0.25 };

export default function DynamicIslandMockup() {
  const [phase, setPhase] = useState<Phase>("recording");

  useEffect(() => {
    const timeout = setTimeout(() => {
      setPhase((prev) => {
        switch (prev) {
          case "recording":
            return "processing";
          case "processing":
            return "expanded";
          case "expanded":
            return "collapsing";
          case "collapsing":
            return "recording";
        }
      });
    }, CYCLE_TIMINGS[phase]);

    return () => clearTimeout(timeout);
  }, [phase]);

  const isExpanded = phase === "expanded";

  return (
    <div className="flex justify-center w-full">
      <motion.div
        layout
        transition={spring}
        className="glass relative overflow-hidden shadow-[0_5px_20px_rgba(0,0,0,0.3)]"
        style={{
          borderRadius: isExpanded ? 22 : 18,
          border: "0.5px solid rgba(255, 255, 255, 0.15)",
        }}
        animate={{
          width: isExpanded ? 500 : 200,
          height: isExpanded ? "auto" : 36,
        }}
      >
        <AnimatePresence mode="wait">
          {phase === "recording" && (
            <motion.div
              key="recording"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 0.15 }}
              className="flex items-center gap-2 px-4 h-9"
            >
              <span className="w-2 h-2 rounded-full bg-red-500 animate-recording-pulse" />
              <span className="text-sm text-zinc-300">Recording...</span>
            </motion.div>
          )}

          {phase === "processing" && (
            <motion.div
              key="processing"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 0.15 }}
              className="flex items-center gap-2 px-4 h-9"
            >
              <svg
                className="w-3.5 h-3.5 text-brand-purple animate-spin-slow"
                viewBox="0 0 24 24"
                fill="none"
              >
                <circle
                  cx="12"
                  cy="12"
                  r="10"
                  stroke="currentColor"
                  strokeWidth="3"
                  strokeLinecap="round"
                  strokeDasharray="50 20"
                />
              </svg>
              <span className="text-sm text-zinc-300">Processing...</span>
            </motion.div>
          )}

          {(phase === "expanded" || phase === "collapsing") && (
            <motion.div
              key="expanded"
              initial={{ opacity: 0 }}
              animate={{ opacity: phase === "collapsing" ? 0 : 1 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 0.2 }}
              className="p-4"
            >
              <div className="flex items-center justify-between mb-3">
                <span className="inline-flex items-center font-mono font-bold text-lg text-brand-green bg-brand-green/10 px-3 py-1 rounded-md border border-brand-green/20">
                  &lt;leader&gt;ff
                </span>
                <span className="text-xs text-zinc-500">Telescope</span>
              </div>
              <p className="text-sm text-zinc-300 mb-3">
                Find files in the project
              </p>
              <div className="space-y-1.5">
                <div className="flex items-center gap-2 text-xs text-zinc-400">
                  <span className="w-4 h-4 rounded-full bg-brand-purple/20 text-brand-purple flex items-center justify-center text-[10px] font-bold">
                    1
                  </span>
                  Press Space (leader key)
                </div>
                <div className="flex items-center gap-2 text-xs text-zinc-400">
                  <span className="w-4 h-4 rounded-full bg-brand-purple/20 text-brand-purple flex items-center justify-center text-[10px] font-bold">
                    2
                  </span>
                  Press f f
                </div>
                <div className="flex items-center gap-2 text-xs text-zinc-400">
                  <span className="w-4 h-4 rounded-full bg-brand-purple/20 text-brand-purple flex items-center justify-center text-[10px] font-bold">
                    3
                  </span>
                  Type filename to search
                </div>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </motion.div>
    </div>
  );
}
