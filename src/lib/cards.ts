import bundledCards from '../data/cards.json';
import type { Card } from '../types';
import { supabase } from './supabase';

// Bump this whenever the card format changes so everyone's cached copy gets thrown away
const CACHE_KEY = 'ea_cards_v2';

// What a row in the supabase cards table looks like (snake_case, unlike the app)
interface CardRow {
	id: string;
	category: string;
	additional_categories: string[] | null;
	order: number;
	deck: string | null;
	english: string;
	arabic: string;
	transliteration: string;
	accepted: string[];
	arabic_variants: string[];
	audio: { ar: string; en: string };
	tags: string[];
	notes: string;
}

function rowToCard(row: CardRow): Card {
	return {
		id: row.id,
		category: row.category,
		additionalCategories: row.additional_categories?.length ? row.additional_categories : undefined,
		order: row.order,
		deck: row.deck ?? undefined,
		english: row.english,
		arabic: row.arabic,
		transliteration: row.transliteration,
		accepted: row.accepted,
		arabicVariants: row.arabic_variants,
		audio: row.audio,
		tags: row.tags,
		notes: row.notes,
	};
}

/** The cards to show straight away, before supabase answers - the last cached copy if there is one, otherwise the ones bundled with the app */
export function getInitialCards(): Card[] {
	try {
		const cached = localStorage.getItem(CACHE_KEY);
		if (cached) {
			const cards = JSON.parse(cached) as Card[];
			if (cards.length > 0) {
				return cards;
			}
		}
	} catch {
		// A broken cache just means we use the bundled cards
	}
	return bundledCards as Card[];
}

/** Loads every card from supabase and caches them for next time. Throws if supabase is unreachable or empty, and the app carries on with what it has */
export async function fetchCardsFromSupabase(): Promise<Card[]> {
	const { data, error } = await supabase.from('cards').select('*').order('order', { ascending: true });
	if (error) {
		throw error;
	}
	if (!data?.length) {
		throw new Error("Supabase didn't return any cards :(");
	}

	const cards = (data as CardRow[]).map(rowToCard);
	try {
		localStorage.setItem(CACHE_KEY, JSON.stringify(cards));
	} catch {
		// Storage can be full or blocked (private browsing), the app still works without the cache
	}
	return cards;
}
