import type { CardProgress, SRSGrade } from '../types'

function addDays(date: Date, days: number): string {
  const d = new Date(date)
  d.setDate(d.getDate() + days)
  return d.toISOString()
}

// SM-2 spaced repetition algorithm
export function calculateNextReview(
  progress: CardProgress,
  grade: SRSGrade
): CardProgress {
  const now = new Date()

  if (grade <= 2) {
    return {
      ...progress,
      intervalDays: grade === 1 ? 1 : 3,
      reps: 0,
      lapses: progress.lapses + (grade === 1 ? 1 : 0),
      dueDate: addDays(now, grade === 1 ? 1 : 3),
      lastReviewed: now.toISOString(),
    }
  }

  const newEase = Math.max(
    1.3,
    progress.easeFactor + 0.1 - (4 - grade) * (0.08 + (4 - grade) * 0.02)
  )

  let newInterval: number
  if (progress.reps === 0) {
    newInterval = 1
  } else if (progress.reps === 1) {
    newInterval = 6
  } else {
    newInterval = Math.round(progress.intervalDays * newEase)
  }

  if (grade === 4) newInterval = Math.round(newInterval * 1.3)

  return {
    ...progress,
    intervalDays: newInterval,
    easeFactor: newEase,
    reps: progress.reps + 1,
    dueDate: addDays(now, newInterval),
    lastReviewed: now.toISOString(),
  }
}

export function newCardProgress(cardId: string): CardProgress {
  return {
    cardId,
    intervalDays: 1,
    easeFactor: 2.5,
    dueDate: new Date().toISOString(),
    reps: 0,
    lapses: 0,
    lastReviewed: null,
    masteryStreak: 0,
    lastCorrectSession: null,
    mastered: false,
    dismissed: false,
    dismissedAt: null,
  }
}

export function isDue(progress: CardProgress): boolean {
  return new Date(progress.dueDate) <= new Date()
}

// Update mastery streak. Call after grading — separate from SRS so mastery
// can be tracked independently of interval scheduling.
export function updateMastery(progress: CardProgress, passed: boolean): CardProgress {
  if (!passed) {
    // Wrong answer resets the streak
    return { ...progress, masteryStreak: 0, mastered: false }
  }

  const today = new Date().toDateString()
  if (progress.lastCorrectSession === today) {
    // Already counted a correct answer today — don't double-count
    return progress
  }

  const newStreak = progress.masteryStreak + 1
  return {
    ...progress,
    masteryStreak: newStreak,
    lastCorrectSession: today,
    mastered: newStreak >= 5,
  }
}

// Mark a card as dismissed by the user ("don't show again").
// Dismissed cards resurface automatically after 7 days.
export function dismissCard(progress: CardProgress): CardProgress {
  return { ...progress, dismissed: true, dismissedAt: new Date().toISOString() }
}

// Returns true if the card should be hidden from study sessions.
export function isDismissed(progress: CardProgress | undefined): boolean {
  if (!progress?.dismissed) return false
  if (!progress.dismissedAt) return true
  const dismissedDate = new Date(progress.dismissedAt)
  const daysSince = (Date.now() - dismissedDate.getTime()) / (1000 * 60 * 60 * 24)
  return daysSince < 7
}
