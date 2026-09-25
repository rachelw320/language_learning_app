import { asc, sql } from 'drizzle-orm';
import type { z } from 'zod';
import type { Card } from '../../shared/card';
import type { newCardSchema } from '../../shared/validation';
import type { Db } from './db';
import { cards, type CardRow, type NewCardRow } from './schema';

// The rds data api caps a request at 64kb, and a card is a few hundred bytes, so this is well inside it
const SEED_BATCH_SIZE = 25;

export type NewCardInput = z.output<typeof newCardSchema>;

/** Everything the api needs from the database. It's an interface so the tests can swap in a fake */
export interface CardRepository {
	list(): Promise<Card[]>;
	create(input: NewCardInput): Promise<Card>;
	upsertMany(list: Card[]): Promise<void>;
}

export function rowToCard(row: CardRow): Card {
	return {
		id: row.id,
		category: row.category,
		additionalCategories: row.additionalCategories?.length ? row.additionalCategories : undefined,
		order: row.order,
		deck: row.deck ?? undefined,
		english: row.english,
		arabic: row.arabic,
		transliteration: row.transliteration,
		accepted: row.accepted,
		arabicVariants: row.arabicVariants,
		audio: row.audio,
		tags: row.tags,
		notes: row.notes,
	};
}

function cardToRow(card: Card): NewCardRow {
	return {
		id: card.id,
		category: card.category,
		additionalCategories: card.additionalCategories ?? null,
		order: card.order,
		deck: card.deck ?? null,
		english: card.english,
		arabic: card.arabic,
		transliteration: card.transliteration,
		accepted: card.accepted,
		arabicVariants: card.arabicVariants,
		audio: card.audio,
		tags: card.tags,
		notes: card.notes,
	};
}

export function cardRepository(db: Db): CardRepository {
	return {
		async list() {
			const rows = await db.select().from(cards).orderBy(asc(cards.order));
			return rows.map(rowToCard);
		},

		async create(input) {
			// New cards go on the end of the deck
			const [{ last }] = await db.select({ last: sql<number>`coalesce(max(${cards.order}), 0)` }).from(cards);
			const row: NewCardRow = {
				id: `card_${Date.now()}`,
				order: Number(last) + 1,
				category: input.category,
				english: input.english,
				arabic: input.arabic,
				transliteration: input.transliteration,
				// If the admin screen didn't send alternatives, the main spelling is the only accepted one
				accepted: input.accepted.length > 0 ? input.accepted : [input.transliteration],
				arabicVariants: input.arabicVariants.length > 0 ? input.arabicVariants : [input.arabic],
				audio: input.audio,
				tags: input.tags,
				notes: input.notes,
			};
			const [inserted] = await db.insert(cards).values(row).returning();
			return rowToCard(inserted);
		},

		// Used by the seed script. Existing cards get updated rather than duplicated, so it's safe to run again
		async upsertMany(list) {
			for (let start = 0; start < list.length; start += SEED_BATCH_SIZE) {
				const batch = list.slice(start, start + SEED_BATCH_SIZE).map(cardToRow);
				await db
					.insert(cards)
					.values(batch)
					.onConflictDoUpdate({
						target: cards.id,
						set: {
							category: sql`excluded.category`,
							additionalCategories: sql`excluded.additional_categories`,
							order: sql`excluded.position`,
							deck: sql`excluded.deck`,
							english: sql`excluded.english`,
							arabic: sql`excluded.arabic`,
							transliteration: sql`excluded.transliteration`,
							accepted: sql`excluded.accepted`,
							arabicVariants: sql`excluded.arabic_variants`,
							audio: sql`excluded.audio`,
							tags: sql`excluded.tags`,
							notes: sql`excluded.notes`,
						},
					});
			}
		},
	};
}
