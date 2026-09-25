import { describe, expect, it } from 'vitest';
import { checkAnswer, checkEnglish, isArabic, PASS_THRESHOLD, similarity } from '../src/lib/matching';

const accepted = ['ya3ni eh', 'ya3ni eih', 'ya3ne eh', 'يعني إيه'];
const arabicVariants = ['يعني إيه؟', 'يعني ايه'];

describe('similarity', () => {
	it('is 1 for identical strings and 0 against an empty one', () => {
		expect(similarity('salam', 'salam')).toBe(1);
		expect(similarity('salam', '')).toBe(0);
	});

	it('drops as the strings drift apart', () => {
		expect(similarity('salam', 'salem')).toBeCloseTo(0.8);
		expect(similarity('salam', 'xyz')).toBeLessThan(PASS_THRESHOLD);
	});
});

describe('isArabic', () => {
	it('spots arabic script', () => {
		expect(isArabic('يعني ايه')).toBe(true);
		expect(isArabic('ya3ni eh')).toBe(false);
	});
});

describe('checkAnswer', () => {
	it('accepts any of the accepted spellings exactly', () => {
		expect(checkAnswer('ya3ne eh', accepted, arabicVariants)).toMatchObject({ passed: true, score: 1, matchedVariant: 'ya3ne eh' });
	});

	it('lets a small typo through', () => {
		expect(checkAnswer('ya3ni ehh', accepted, arabicVariants).passed).toBe(true);
	});

	it('rejects something completely different', () => {
		expect(checkAnswer('shukran', accepted, arabicVariants).passed).toBe(false);
	});

	it('checks arabic script against the arabic spellings, ignoring punctuation', () => {
		const result = checkAnswer('يعني ايه', accepted, arabicVariants);
		expect(result.passed).toBe(true);
		expect(result.matchedVariant).toBe('يعني إيه؟');
	});
});

describe('checkEnglish', () => {
	it('ignores case, apostrophes and the bracketed notes', () => {
		expect(checkEnglish('you go', 'You go (to a man)').passed).toBe(true);
		expect(checkEnglish('Im fine', "I'm fine (f)").score).toBe(1);
	});

	it('still fails a wrong meaning', () => {
		expect(checkEnglish('goodbye', 'hello').passed).toBe(false);
	});
});
