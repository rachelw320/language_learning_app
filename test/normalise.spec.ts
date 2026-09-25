import { describe, expect, it } from 'vitest';
import { normaliseArabic, normaliseEnglish, normaliseTransliteration, stripQualifiers } from '../src/lib/normalise';

describe('normaliseArabic', () => {
	it('ignores diacritics, punctuation and the different alef forms', () => {
		expect(normaliseArabic('يعني إيه؟')).toBe('يعني ايه');
		expect(normaliseArabic('مَرْحَبًا')).toBe('مرحبا');
	});

	it('treats ta marbuta and ha the same', () => {
		expect(normaliseArabic('حاجة')).toBe(normaliseArabic('حاجه'));
	});
});

describe('normaliseTransliteration', () => {
	it('lowercases and smooths out the common spelling differences', () => {
		expect(normaliseTransliteration('Ya3ni Eih')).toBe('ya3ni eh');
		expect(normaliseTransliteration('shookran')).toBe('shukran');
	});

	it('keeps 2 and 3 but drops other numbers and punctuation', () => {
		expect(normaliseTransliteration('3ayez 7aga, ya2ni?')).toBe('3ayez aga ya2ni');
	});
});

describe('stripQualifiers and normaliseEnglish', () => {
	it('drop the bracketed notes', () => {
		expect(stripQualifiers('You go (to a man)')).toBe('You go');
		expect(normaliseEnglish("I'm fine (f)")).toBe('im fine');
	});
});
