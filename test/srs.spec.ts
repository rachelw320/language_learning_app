import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { calculateNextReview, dismissCard, isDismissed, MASTERY_STREAK, newCardProgress, updateMastery } from '../src/lib/srs';

const DAY_MS = 24 * 60 * 60 * 1000;

beforeEach(() => {
	vi.useFakeTimers();
	vi.setSystemTime(new Date('2026-09-25T10:00:00Z'));
});

afterEach(() => {
	vi.useRealTimers();
});

describe('calculateNextReview', () => {
	it('starts a new card at one day, then six', () => {
		const first = calculateNextReview(newCardProgress('card_001'), 3);
		expect(first.intervalDays).toBe(1);
		expect(first.reps).toBe(1);
		expect(calculateNextReview(first, 3).intervalDays).toBe(6);
	});

	it('keeps the ease factor steady on a plain correct answer', () => {
		expect(calculateNextReview(newCardProgress('card_001'), 3).easeFactor).toBe(2.5);
	});

	it('resets a card you get wrong and counts the lapse', () => {
		const learned = calculateNextReview(calculateNextReview(newCardProgress('card_001'), 3), 3);
		const wrong = calculateNextReview(learned, 1);
		expect(wrong.intervalDays).toBe(1);
		expect(wrong.reps).toBe(0);
		expect(wrong.lapses).toBe(1);
	});
});

describe('updateMastery', () => {
	it('only counts one correct answer a day', () => {
		const once = updateMastery(newCardProgress('card_001'), true);
		expect(once.masteryStreak).toBe(1);
		expect(updateMastery(once, true).masteryStreak).toBe(1);
	});

	it('masters a card after enough different days', () => {
		let progress = newCardProgress('card_001');
		for (let day = 0; day < MASTERY_STREAK; day++) {
			vi.setSystemTime(new Date(Date.now() + DAY_MS));
			progress = updateMastery(progress, true);
		}
		expect(progress.mastered).toBe(true);
	});

	it('resets the streak on a wrong answer', () => {
		const progress = updateMastery(updateMastery(newCardProgress('card_001'), true), false);
		expect(progress.masteryStreak).toBe(0);
		expect(progress.mastered).toBe(false);
	});
});

describe('dismissCard and isDismissed', () => {
	it('hides a card for a week and then brings it back', () => {
		const dismissed = dismissCard(newCardProgress('card_001'));
		expect(isDismissed(dismissed)).toBe(true);
		vi.setSystemTime(new Date(Date.now() + 8 * DAY_MS));
		expect(isDismissed(dismissed)).toBe(false);
	});

	it('is false for a card with no progress', () => {
		expect(isDismissed(undefined)).toBe(false);
	});
});
