"use client";

export default function KeySequencePill({
  keys,
  size = "md",
}: {
  keys: string;
  size?: "sm" | "md" | "lg";
}) {
  const sizeClasses = {
    sm: "px-2 py-0.5 text-xs",
    md: "px-3 py-1 text-sm",
    lg: "px-4 py-1.5 text-base",
  };

  return (
    <span
      className={`inline-flex items-center font-mono font-semibold rounded-md bg-brand-purple/20 text-brand-purple border border-brand-purple/30 ${sizeClasses[size]}`}
    >
      {keys}
    </span>
  );
}
