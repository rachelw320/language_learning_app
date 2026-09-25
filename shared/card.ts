// The card shape the app and the api agree on. The database has its own row shape in api/src/schema.ts
export interface Card {
	id: string;
	category: string;
	// A card can show up in more than one category. Mastery is per card id so it's shared between them
	additionalCategories?: string[];
	order: number;
	deck?: string;
	english: string;
	arabic: string;
	transliteration: string;
	// Every transliteration spelling that counts as correct
	accepted: string[];
	// Every arabic spelling that counts as correct
	arabicVariants: string[];
	audio: { ar: string; en: string };
	tags: string[];
	notes: string;
}
