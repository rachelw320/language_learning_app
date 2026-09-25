import { describe, expect, it } from 'vitest';
import { getCardsForCategory, getCategories, getTagGroups, getVerbGroups, isVerbCategory, shuffle } from '../src/lib/categories';
import type { Card } from '../src/types';

function card(id: string, category: string, order: number, english: string, tags: string[], extra: Partial<Card> = {}): Card {
	return {
		id,
		category,
		order,
		english,
		arabic: '',
		transliteration: `${english} translit`,
		accepted: [],
		arabicVariants: [],
		audio: { ar: '', en: '' },
		tags,
		notes: '',
		...extra,
	};
}

const cards = [
	card('c1', 'Essentials', 2, 'Hello', ['essentials', 'greetings']),
	card('c2', 'Essentials', 1, 'Thanks', ['essentials', 'greetings']),
	card('c3', 'Essentials', 3, 'Where?', ['essentials', 'questions'], { additionalCategories: ['Directions'] }),
	card('c4', 'Verbs', 2, 'He goes', ['verbs', 'go'], { arabic: 'بيروح', transliteration: 'beyerooh' }),
	card('c5', 'Verbs', 1, 'I go', ['verbs', 'go']),
];

describe('getCategories', () => {
	it('lists each category once, including extra ones a card belongs to', () => {
		expect(getCategories(cards)).toEqual(['Essentials', 'Directions', 'Verbs']);
	});
});

describe('getCardsForCategory', () => {
	it('sorts by order and includes cards that list the category as an extra', () => {
		expect(getCardsForCategory(cards, 'Essentials').map((c) => c.id)).toEqual(['c2', 'c1', 'c3']);
		expect(getCardsForCategory(cards, 'Directions').map((c) => c.id)).toEqual(['c3']);
	});
});

describe('grouping', () => {
	it('knows a verb category when it sees one', () => {
		expect(isVerbCategory(getCardsForCategory(cards, 'Verbs'))).toBe(true);
		expect(isVerbCategory(getCardsForCategory(cards, 'Essentials'))).toBe(false);
	});

	it('names verb groups after the he form', () => {
		const [go] = getVerbGroups(getCardsForCategory(cards, 'Verbs'));
		expect(go.label).toBe('beyerooh');
		expect(go.labelArabic).toBe('بيروح');
		expect(go.cards.map((c) => c.id)).toEqual(['c5', 'c4']);
	});

	it('groups topic cards by their second tag with a capitalised label', () => {
		const groups = getTagGroups(getCardsForCategory(cards, 'Essentials'));
		expect(groups.map((g) => g.label)).toEqual(['Greetings', 'Questions']);
		expect(groups[0].cards.map((c) => c.id)).toEqual(['c2', 'c1']);
	});
});

describe('shuffle', () => {
	it('keeps every card and leaves the original alone', () => {
		const shuffled = shuffle(cards);
		expect(shuffled).toHaveLength(cards.length);
		expect(new Set(shuffled)).toEqual(new Set(cards));
		expect(cards.map((c) => c.id)).toEqual(['c1', 'c2', 'c3', 'c4', 'c5']);
	});
});
