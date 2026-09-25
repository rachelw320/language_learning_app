import bundledCards from '../data/cards.json';
import type { Card } from '../types';
import { fetchCards, hasApi } from './api';

// Bump this whenever the card format changes so everyone's cached copy gets thrown away
const CACHE_KEY = 'ea_cards_v2';

/** The cards to show straight away, before the api answers - the last cached copy if there is one, otherwise the ones bundled with the app */
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

/** Loads every card from the api and caches them for next time. Throws if there's no api or it's unreachable, and the app carries on with what it has */
export async function fetchLiveCards(): Promise<Card[]> {
	if (!hasApi) {
		throw new Error('No api configured');
	}
	const cards = await fetchCards();
	if (cards.length === 0) {
		throw new Error("The api didn't return any cards :(");
	}
	try {
		localStorage.setItem(CACHE_KEY, JSON.stringify(cards));
	} catch {
		// Storage can be full or blocked (private browsing), the app still works without the cache
	}
	return cards;
}
