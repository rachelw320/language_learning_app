import { z } from 'zod';

const nonEmpty = z.string().trim().min(1);

/** What the admin screen sends to create a card. The api fills in the id and position */
export const newCardSchema = z.object({
	category: nonEmpty,
	english: nonEmpty,
	arabic: nonEmpty,
	transliteration: nonEmpty,
	accepted: z.array(z.string()).default([]),
	arabicVariants: z.array(z.string()).default([]),
	audio: z.object({ ar: z.string().default(''), en: z.string().default('') }).default({ ar: '', en: '' }),
	tags: z.array(z.string()).default([]),
	notes: z.string().default(''),
});

export type NewCard = z.input<typeof newCardSchema>;

export const audioLanguageSchema = z.enum(['ar', 'en']);
export type AudioLanguage = z.infer<typeof audioLanguageSchema>;

// The three things the admin screen can produce: a safari recording, a chrome recording, or an elevenlabs mp3
export const audioContentTypeSchema = z.enum(['audio/mp4', 'audio/webm', 'audio/mpeg']);

export const uploadUrlSchema = z.object({
	language: audioLanguageSchema,
	contentType: audioContentTypeSchema,
});

export const ttsSchema = z.object({
	text: nonEmpty.max(500),
	language: audioLanguageSchema,
});
