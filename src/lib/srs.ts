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
    // Again or Hard — reset
    return {
      ...progress,
      intervalDays: grade === 1 ? 1 : 3,
      reps: 0,
      lapses: progress.lapses + (grade === 1 ? 1 : 0),
      dueDate: addDays(now, grade === 1 ? 1 : 3),
      lastReviewed: now.toISOString(),
    }
  }

  // Good or Easy
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
  }
}

export function isDue(progress: CardProgress): boolean {
  return new Date(progress.dueDate) <= new Date()
}
