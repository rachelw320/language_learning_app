import { normalizeArabic, normalizeTranslit } from './normalizeText'

// Levenshtein distance — counts minimum edits between two strings
function levenshtein(a: string, b: string): number {
  const m = a.length
  const n = b.length
  const dp: number[][] = Array.from({ length: m + 1 }, (_, i) =>
    Array.from({ length: n + 1 }, (_, j) => (i === 0 ? j : j === 0 ? i : 0))
  )
  for (let i = 1; i <= m; i++) {
    for (let j = 1; j <= n; j++) {
      dp[i][j] =
        a[i - 1] === b[j - 1]
          ? dp[i - 1][j - 1]
          : 1 + Math.min(dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1])
    }
  }
  return dp[m][n]
}

// Similarity 0–1 (1 = identical)
function similarity(a: string, b: string): number {
  if (a === b) return 1
  if (a.length === 0 || b.length === 0) return 0
  const dist = levenshtein(a, b)
  return 1 - dist / Math.max(a.length, b.length)
}

// Detect if a string is mostly Arabic script
function isArabic(text: string): boolean {
  const arabicChars = (text.match(/[؀-ۿ]/g) || []).length
  return arabicChars / text.length > 0.4
}

interface MatchResult {
  score: number
  passed: boolean
  matchedVariant: string
}

// THRESHOLD: how similar the answer needs to be to pass (0–1)
const PASS_THRESHOLD = 0.72

// Strip parenthetical qualifiers: "I go (f)" → "I go", "you go (to a man)" → "you go"
function stripQualifiers(text: string): string {
  return text.replace(/\([^)]*\)/g, '').replace(/\s+/g, ' ').trim()
}

function normalizeEnglish(text: string): string {
  return stripQualifiers(text).toLowerCase().replace(/[''`]/g, '').trim()
}

export function checkEnglish(userInput: string, expected: string): { score: number; passed: boolean } {
  const a = normalizeEnglish(userInput)
  const b = normalizeEnglish(expected)
  if (a === b) return { score: 1, passed: true }
  const score = similarity(a, b)
  return { score, passed: score >= PASS_THRESHOLD }
}

export function checkAnswer(
  userInput: string,
  accepted: string[],
  arabicVariants: string[]
): MatchResult {
  const inputIsArabic = isArabic(userInput)

  let best = { score: 0, matchedVariant: '' }

  if (inputIsArabic) {
    // Compare against Arabic variants
    const normInput = normalizeArabic(userInput)
    for (const variant of [...arabicVariants, ...accepted.filter(isArabic)]) {
      const score = similarity(normInput, normalizeArabic(variant))
      if (score > best.score) best = { score, matchedVariant: variant }
    }
  } else {
    // Compare against transliteration variants
    const normInput = normalizeTranslit(userInput)
    for (const variant of accepted.filter(v => !isArabic(v))) {
      const score = similarity(normInput, normalizeTranslit(variant))
      if (score > best.score) best = { score, matchedVariant: variant }
    }
  }

  return {
    score: best.score,
    passed: best.score >= PASS_THRESHOLD,
    matchedVariant: best.matchedVariant,
  }
}
