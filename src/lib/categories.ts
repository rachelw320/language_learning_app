import type { Card } from '../types';

function categoriesOf(card: Card): string[] {
	return card.additionalCategories ? [card.category, ...card.additionalCategories] : [card.category];
}

/** Every category, in the order they first appear in the deck */
export function getCategories(cards: Card[]): string[] {
	const seen = new Set<string>();
	for (const card of cards) {
		for (const category of categoriesOf(card)) {
			seen.add(category);
		}
	}
	return [...seen];
}

export function getCardsForCategory(cards: Card[], category: string): Card[] {
	return cards.filter((card) => categoriesOf(card).includes(category)).sort((a, b) => a.order - b.order);
}

/** Fisher-Yates shuffle. Returns a new array and leaves the original alone */
export function shuffle<T>(items: T[]): T[] {
	const shuffled = [...items];
	for (let i = shuffled.length - 1; i > 0; i--) {
		const j = Math.floor(Math.random() * (i + 1));
		[shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
	}
	return shuffled;
}

export interface CardGroup {
	tag: string;
	label: string;
	// Only verb groups have this
	labelArabic?: string;
	cards: Card[];
}

// Cards are tagged [kind, group], e.g. ["verbs", "go"] or ["essentials", "greetings"], and the second tag is what we group by
function groupBySecondTag(cards: Card[]): Map<string, Card[]> {
	const groups = new Map<string, Card[]>();
	for (const card of cards) {
		const tag = card.tags[1] ?? 'other';
		const group = groups.get(tag) ?? [];
		group.push(card);
		groups.set(tag, group);
	}
	for (const group of groups.values()) {
		group.sort((a, b) => a.order - b.order);
	}
	return groups;
}

/** A category counts as a verb category if its cards are tagged "verbs" first */
export function isVerbCategory(cards: Card[]): boolean {
	return cards.some((card) => card.tags[0] === 'verbs');
}

/** Groups a topic category by its second tag, e.g. "greetings" or "questions" */
export function getTagGroups(cards: Card[]): CardGroup[] {
	return [...groupBySecondTag(cards)].map(([tag, groupCards]) => ({
		tag,
		label: tag.charAt(0).toUpperCase() + tag.slice(1),
		cards: groupCards,
	}));
}

/** Groups conjugations by verb, named after the "he" form (e.g. "beyerooh" / بيروح) since that's how arabic verbs are usually listed */
export function getVerbGroups(cards: Card[]): CardGroup[] {
	return [...groupBySecondTag(cards)].map(([tag, groupCards]) => {
		const heForm = groupCards.find((card) => /^he\b/i.test(card.english));
		return {
			tag,
			label: heForm?.transliteration ?? tag,
			labelArabic: heForm?.arabic ?? '',
			cards: groupCards,
		};
	});
}
