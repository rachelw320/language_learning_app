import { index, integer, jsonb, pgTable, text, timestamp } from 'drizzle-orm/pg-core';

// One row per card. The list fields are jsonb rather than postgres arrays because the rds data api is awkward with arrays
export const cards = pgTable(
	'cards',
	{
		id: text('id').primaryKey(),
		category: text('category').notNull(),
		additionalCategories: jsonb('additional_categories').$type<string[]>(),
		// Where the card sits in its category. It's "position" in the table because "order" is a reserved word in sql
		order: integer('position').notNull(),
		deck: text('deck'),
		english: text('english').notNull(),
		arabic: text('arabic').notNull(),
		transliteration: text('transliteration').notNull(),
		accepted: jsonb('accepted').$type<string[]>().notNull(),
		arabicVariants: jsonb('arabic_variants').$type<string[]>().notNull(),
		audio: jsonb('audio').$type<{ ar: string; en: string }>().notNull(),
		tags: jsonb('tags').$type<string[]>().notNull(),
		notes: text('notes').notNull().default(''),
		createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
	},
	(table) => [index('cards_category_idx').on(table.category)],
);

export type CardRow = typeof cards.$inferSelect;
export type NewCardRow = typeof cards.$inferInsert;
