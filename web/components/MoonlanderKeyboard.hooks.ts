"use client";

import { useMemo, useEffect, useState, type RefObject } from "react";
import { useInView } from "framer-motion";
import type { AnimationStep } from "./MoonlanderKeyboard.data";

type AnimPhase = "idle" | "step1" | "step2" | "step3" | "fadeout";

const PHASE_DURATIONS: Record<AnimPhase, number> = {
  idle: 2000,
  step1: 600,
  step2: 600,
  step3: 1800,
  fadeout: 300,
};

const NEXT_PHASE: Record<AnimPhase, AnimPhase> = {
  idle: "step1",
  step1: "step2",
  step2: "step3",
  step3: "fadeout",
  fadeout: "idle",
};

export function useKeySequenceAnimation(
  steps: AnimationStep[],
  containerRef: RefObject<HTMLElement | null>,
) {
  const isInView = useInView(containerRef, { amount: 0.3 });
  const [phase, setPhase] = useState<AnimPhase>("idle");

  // Phase timer — only ticks when in view
  useEffect(() => {
    if (!isInView) {
      setPhase("idle");
      return;
    }

    const timeout = setTimeout(() => {
      setPhase((prev) => NEXT_PHASE[prev]);
    }, PHASE_DURATIONS[phase]);

    return () => clearTimeout(timeout);
  }, [phase, isInView]);

  // Derive highlighted keys from current phase
  const { highlightedKeys, activeStepIndex, isAnimating } = useMemo(() => {
    const map = new Map<string, number>();
    let stepIdx = -1;

    if (phase === "step1") {
      map.set(steps[0].keyId, steps[0].stepNumber);
      stepIdx = 0;
    } else if (phase === "step2") {
      map.set(steps[0].keyId, steps[0].stepNumber);
      map.set(steps[1].keyId, steps[1].stepNumber);
      stepIdx = 1;
    } else if (phase === "step3") {
      map.set(steps[0].keyId, steps[0].stepNumber);
      map.set(steps[2].keyId, steps[2].stepNumber); // overwrites step 2 on same key
      stepIdx = 2;
    }

    return {
      highlightedKeys: map,
      activeStepIndex: stepIdx,
      isAnimating:
        phase === "step1" || phase === "step2" || phase === "step3",
    };
  }, [phase, steps]);

  return { highlightedKeys, activeStepIndex, isAnimating };
}
