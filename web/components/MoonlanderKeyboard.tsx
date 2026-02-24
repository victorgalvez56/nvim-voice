"use client";

import { useRef, memo } from "react";
import { motion, AnimatePresence } from "framer-motion";
import {
  leftKeys,
  rightKeys,
  leaderFFSequence,
  type KeyDef,
} from "./MoonlanderKeyboard.data";
import { useKeySequenceAnimation } from "./MoonlanderKeyboard.hooks";

// ---------- KeyCap ----------

const KeyCap = memo(function KeyCap({
  keyDef,
  stepNumber,
  isAnimating,
}: {
  keyDef: KeyDef;
  stepNumber: number | undefined;
  isAnimating: boolean;
}) {
  const isHighlighted = stepNumber !== undefined;
  const isDimmed = isAnimating && !isHighlighted;

  let bg: string;
  let text: string;
  let border: string;

  if (isHighlighted) {
    bg = "bg-brand-purple/[0.35]";
    text = "text-white";
    border = "border-brand-purple/30";
  } else if (keyDef.category === "modifier") {
    bg = "bg-brand-green/10";
    text = "text-brand-green";
    border = "border-brand-green/10";
  } else {
    bg = "bg-brand-surface";
    text = "text-zinc-400";
    border = "border-white/[0.06]";
  }

  return (
    <motion.div
      className={`relative flex items-center justify-center rounded-lg border font-mono select-none
        w-[var(--key-size)] h-[var(--key-size)]
        ${bg} ${text} ${border}`}
      animate={{
        scale: isHighlighted ? 1.08 : 1,
        opacity: isDimmed ? 0.35 : 1,
        boxShadow: isHighlighted
          ? "0 0 20px rgba(155, 109, 255, 0.4)"
          : "0 0 0px rgba(155, 109, 255, 0)",
      }}
      transition={{ duration: 0.25 }}
    >
      <span className="truncate px-0.5">{keyDef.label}</span>

      <AnimatePresence mode="wait">
        {isHighlighted && (
          <motion.span
            key={stepNumber}
            initial={{ scale: 0, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 0, opacity: 0 }}
            transition={{ duration: 0.15 }}
            className="absolute -top-2 -right-2 w-4 h-4 rounded-full bg-brand-purple text-white text-[10px] font-bold font-sans flex items-center justify-center shadow-lg"
          >
            {stepNumber}
          </motion.span>
        )}
      </AnimatePresence>
    </motion.div>
  );
});

// ---------- Spacer — invisible block matching N key slots ----------

function KeySpacer({ count }: { count: number }) {
  // Width = count * keySize + (count - 1) * gap
  // e.g. count=2 → 2K + G, count=4 → 4K + 3G
  return (
    <div
      className="shrink-0"
      style={{
        width: `calc(${count} * var(--key-size) + ${count - 1} * var(--key-gap))`,
      }}
    />
  );
}

// ---------- Half — mirrors the SwiftUI moonlanderView layout ----------

function KeyboardHalf({
  keys,
  hand,
  highlightedKeys,
  isAnimating,
}: {
  keys: KeyDef[];
  hand: "left" | "right";
  highlightedKeys: Map<string, number>;
  isAnimating: boolean;
}) {
  const mainRows = [0, 1, 2, 3].map((r) => keys.filter((k) => k.row === r));
  const fnRow = keys.filter((k) => k.row === 4);
  const thumbKeys = keys.filter((k) => k.row === 5);

  const renderKeys = (row: KeyDef[]) =>
    row.map((k) => (
      <KeyCap
        key={k.id}
        keyDef={k}
        stepNumber={highlightedKeys.get(k.id)}
        isAnimating={isAnimating}
      />
    ));

  return (
    <div className="flex flex-col gap-[var(--key-gap)]">
      {/* Main rows (7 keys each) */}
      {mainRows.map((row, i) => (
        <div key={i} className="flex gap-[var(--key-gap)]">
          {renderKeys(row)}
        </div>
      ))}

      {/* Fn row (5 keys) — pinky (outer) edge, 2-key spacer on inner edge */}
      <div className="flex gap-[var(--key-gap)]">
        {hand === "right" && <KeySpacer count={2} />}
        {renderKeys(fnRow)}
        {hand === "left" && <KeySpacer count={2} />}
      </div>

      {/* Thumb cluster (3 keys) — inner edge, 4-key spacer on outer edge */}
      <div className="flex gap-[var(--key-gap)]">
        {hand === "left" && <KeySpacer count={4} />}
        {renderKeys(thumbKeys)}
        {hand === "right" && <KeySpacer count={4} />}
      </div>
    </div>
  );
}

// ---------- Main ----------

export default function MoonlanderKeyboard() {
  const containerRef = useRef<HTMLDivElement>(null);
  const { highlightedKeys, isAnimating } = useKeySequenceAnimation(
    leaderFFSequence,
    containerRef,
  );

  return (
    <div
      ref={containerRef}
      className={[
        "[--key-size:30px] [--key-gap:2px] text-[9px]",
        "md:[--key-size:36px] md:[--key-gap:3px] md:text-[10px]",
        "lg:[--key-size:44px] lg:[--key-gap:3px] lg:text-[11px]",
      ].join(" ")}
    >
      <div className="flex flex-col items-center gap-6 md:flex-row md:justify-center md:gap-[calc(var(--key-size)*0.9)]">
        <KeyboardHalf
          keys={leftKeys}
          hand="left"
          highlightedKeys={highlightedKeys}
          isAnimating={isAnimating}
        />
        <KeyboardHalf
          keys={rightKeys}
          hand="right"
          highlightedKeys={highlightedKeys}
          isAnimating={isAnimating}
        />
      </div>
    </div>
  );
}
