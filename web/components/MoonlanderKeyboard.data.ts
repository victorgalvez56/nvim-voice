export type KeyCategory = "regular" | "modifier" | "thumb";

export interface KeyDef {
  id: string;
  label: string;
  category: KeyCategory;
  row: number; // 0-3 main, 4 fn, 5 thumb
  col: number;
  hand: "left" | "right";
}

export interface AnimationStep {
  stepNumber: number;
  keyId: string;
  delay: number;
}

// ---------- helpers ----------

const LEFT_MODIFIERS = new Set([
  "l-r1-c0", // Tab
  "l-r2-c0", // Esc
  "l-r3-c0", // Shf
  "l-fn-c4", // Ctrl
]);

const RIGHT_MODIFIERS = new Set([
  "r-r2-c6", // Ret
  "r-r3-c6", // Shf
  "r-fn-c0", // Ctrl
]);

function buildHalf(
  hand: "left" | "right",
  mainLabels: string[][],
  fnLabels: string[],
  thumbLabels: string[],
  modifiers: Set<string>,
): KeyDef[] {
  const keys: KeyDef[] = [];

  mainLabels.forEach((row, r) => {
    row.forEach((label, c) => {
      const id = `${hand[0]}-r${r}-c${c}`;
      keys.push({
        id,
        label,
        category: modifiers.has(id) ? "modifier" : "regular",
        row: r,
        col: c,
        hand,
      });
    });
  });

  fnLabels.forEach((label, c) => {
    const id = `${hand[0]}-fn-c${c}`;
    keys.push({
      id,
      label,
      category: modifiers.has(id) ? "modifier" : "regular",
      row: 4,
      col: c,
      hand,
    });
  });

  thumbLabels.forEach((label, c) => {
    const id = `${hand[0]}-th-c${c}`;
    keys.push({ id, label, category: "thumb", row: 5, col: c, hand });
  });

  return keys;
}

// ---------- Left half (36 keys) ----------

export const leftKeys: KeyDef[] = buildHalf(
  "left",
  [
    ["=", "1", "2", "3", "4", "5", "`"],
    ["Tab", "Q", "W", "E", "R", "T", "["],
    ["Esc", "A", "S", "D", "F", "G", "]"],
    ["Shf", "Z", "X", "C", "V", "B", "\\"],
  ],
  ["`", "\u2190", "\u2192", "~", "Ctrl"],
  ["Bk", "Del", "Spc"],
  LEFT_MODIFIERS,
);

// ---------- Right half (36 keys) ----------

export const rightKeys: KeyDef[] = buildHalf(
  "right",
  [
    ["`", "6", "7", "8", "9", "0", "-"],
    ["]", "Y", "U", "I", "O", "P", "\\"],
    ["'", "H", "J", "K", "L", ";", "Ret"],
    ["/", "N", "M", ",", ".", "?", "Shf"],
  ],
  ["Ctrl", "~", "\u2191", "\u2193", "`"],
  ["Ent", "Pg\u2193", "Pg\u2191"],
  RIGHT_MODIFIERS,
);

// ---------- Animation: <leader>ff ----------
// Space (left thumb c2) -> f (left home row c4) -> f (same key)

export const leaderFFSequence: AnimationStep[] = [
  { stepNumber: 1, keyId: "l-th-c2", delay: 0 },
  { stepNumber: 2, keyId: "l-r2-c4", delay: 600 },
  { stepNumber: 3, keyId: "l-r2-c4", delay: 600 },
];
