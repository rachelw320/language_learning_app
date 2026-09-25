export type StudyMode = 'english-to-arabic' | 'arabic-to-english' | 'browse';

export type AppScreen =
	| { type: 'home' }
	| { type: 'category'; categoryName: string }
	| { type: 'study'; mode: StudyMode; category: string; sessionName: string; cards: Card[] }
	| { type: 'summary'; mode: StudyMode; category: string; sessionName: string; cards: Card[]; correct: Card[]; incorrect: Card[] }
	| { type: 'admin' };

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

export interface CardProgress {
	cardId: string;
	// sm-2 scheduling
	intervalDays: number;
	easeFactor: number;
	dueDate: string;
	reps: number;
	lapses: number;
	lastReviewed: string | null;
	// Mastery is a streak of correct answers on different days, tracked separately from sm-2
	masteryStreak: number;
	lastCorrectSession: string | null;
	mastered: boolean;
	// "Don't show again" hides the card for a week
	dismissed: boolean;
	dismissedAt: string | null;
}

// 1 = wrong, 4 = easy. The app only ever uses 1 and 3 at the moment
export type SRSGrade = 1 | 2 | 3 | 4;
