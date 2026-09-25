import { normaliseArabic, normaliseEnglish, normaliseTransliteration } from './normalise';

// How close an answer has to be to count. 0.72 lets a typo or an alternative spelling through without accepting rubbish
export const PASS_THRESHOLD = 0.72;

export interface MatchResult {
	score: number;
	passed: boolean;
	matchedVariant: string;
}

/** Levenshtein distance - how many single character edits it takes to turn a into b */
function editDistance(a: string, b: string): number {
	const distances: number[][] = Array.from({ length: a.length + 1 }, (_, i) =>
		Array.from({ length: b.length + 1 }, (_, j) => (i === 0 ? j : j === 0 ? i : 0)),
	);
	for (let i = 1; i <= a.length; i++) {
		for (let j = 1; j <= b.length; j++) {
			const substitution = a[i - 1] === b[j - 1] ? 0 : 1;
			distances[i][j] = Math.min(distances[i - 1][j] + 1, distances[i][j - 1] + 1, distances[i - 1][j - 1] + substitution);
		}
	}
	return distances[a.length][b.length];
}

/** Turns the edit distance into a score from 0 to 1, where 1 means identical */
export function similarity(a: string, b: string): number {
	if (a === b) {
		return 1;
	}
	if (a.length === 0 || b.length === 0) {
		return 0;
	}
	return 1 - editDistance(a, b) / Math.max(a.length, b.length);
}

/** True if most of the text is arabic script, which means the answer should be checked against the arabic spellings */
export function isArabic(text: string): boolean {
	const arabicCharacters = (text.match(/[؀-ۿ]/g) ?? []).length;
	return arabicCharacters / text.length > 0.4;
}

function bestMatch(answer: string, variants: string[], normalise: (text: string) => string): MatchResult {
	const normalisedAnswer = normalise(answer);
	let best = { score: 0, matchedVariant: '' };
	for (const variant of variants) {
		const score = similarity(normalisedAnswer, normalise(variant));
		if (score > best.score) {
			best = { score, matchedVariant: variant };
		}
	}
	return { ...best, passed: best.score >= PASS_THRESHOLD };
}

/**
 * Checks a typed answer against everything the card accepts and returns the closest match.
 * Arabic script is compared with the arabic spellings, anything else with the transliterations
 */
export function checkAnswer(answer: string, accepted: string[], arabicVariants: string[]): MatchResult {
	if (isArabic(answer)) {
		return bestMatch(answer, [...arabicVariants, ...accepted.filter(isArabic)], normaliseArabic);
	}
	return bestMatch(
		answer,
		accepted.filter((variant) => !isArabic(variant)),
		normaliseTransliteration,
	);
}

/** Checks a typed english meaning against the card's english, ignoring bracketed notes like "(f)" */
export function checkEnglish(answer: string, expected: string): MatchResult {
	return bestMatch(answer, [expected], normaliseEnglish);
}
