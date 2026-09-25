import type { CardProgress, SRSGrade } from '../types';

// A card counts as mastered after this many correct answers on different days
export const MASTERY_STREAK = 5;
// "Don't show again" hides a card for this long, then it comes back on its own
const DISMISS_DAYS = 7;
// The usual sm-2 starting point and floor for the ease factor
const STARTING_EASE = 2.5;
const MINIMUM_EASE = 1.3;

function addDays(date: Date, days: number): string {
	const result = new Date(date);
	result.setDate(result.getDate() + days);
	return result.toISOString();
}

export function newCardProgress(cardId: string): CardProgress {
	return {
		cardId,
		intervalDays: 1,
		easeFactor: STARTING_EASE,
		dueDate: new Date().toISOString(),
		reps: 0,
		lapses: 0,
		lastReviewed: null,
		masteryStreak: 0,
		lastCorrectSession: null,
		mastered: false,
		dismissed: false,
		dismissedAt: null,
	};
}

/**
 * sm-2 spaced repetition. A grade of 1 or 2 means the card was wrong (or nearly), so it comes back in a day or three
 * and starts over. 3 or 4 pushes the next review further out each time, by more the easier the card has been
 */
export function calculateNextReview(progress: CardProgress, grade: SRSGrade): CardProgress {
	const now = new Date();

	if (grade <= 2) {
		const days = grade === 1 ? 1 : 3;
		return {
			...progress,
			intervalDays: days,
			reps: 0,
			lapses: progress.lapses + (grade === 1 ? 1 : 0),
			dueDate: addDays(now, days),
			lastReviewed: now.toISOString(),
		};
	}

	const ease = Math.max(MINIMUM_EASE, progress.easeFactor + 0.1 - (4 - grade) * (0.08 + (4 - grade) * 0.02));

	let days: number;
	if (progress.reps === 0) {
		days = 1;
	} else if (progress.reps === 1) {
		days = 6;
	} else {
		days = Math.round(progress.intervalDays * ease);
	}
	if (grade === 4) {
		days = Math.round(days * 1.3);
	}

	return {
		...progress,
		intervalDays: days,
		easeFactor: ease,
		reps: progress.reps + 1,
		dueDate: addDays(now, days),
		lastReviewed: now.toISOString(),
	};
}

/**
 * Bumps the mastery streak after a correct answer, but only once a day so you can't master a card in one sitting.
 * A wrong answer resets it. It's kept separate from sm-2 so the two can't interfere with each other
 */
export function updateMastery(progress: CardProgress, passed: boolean): CardProgress {
	if (!passed) {
		return { ...progress, masteryStreak: 0, mastered: false };
	}

	const today = new Date().toDateString();
	if (progress.lastCorrectSession === today) {
		return progress;
	}

	const streak = progress.masteryStreak + 1;
	return { ...progress, masteryStreak: streak, lastCorrectSession: today, mastered: streak >= MASTERY_STREAK };
}

/** Hides the card from study sessions for a week */
export function dismissCard(progress: CardProgress): CardProgress {
	return { ...progress, dismissed: true, dismissedAt: new Date().toISOString() };
}

/** Whether the card is currently hidden. Cards dismissed more than a week ago come back by themselves */
export function isDismissed(progress: CardProgress | undefined): boolean {
	if (!progress?.dismissed) {
		return false;
	}
	if (!progress.dismissedAt) {
		return true;
	}
	const daysSinceDismissed = (Date.now() - new Date(progress.dismissedAt).getTime()) / (1000 * 60 * 60 * 24);
	return daysSinceDismissed < DISMISS_DAYS;
}
