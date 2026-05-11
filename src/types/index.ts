export type StudyMode = 'flashcard' | 'writing' | 'browse'

export type AppScreen =
  | { type: 'home' }
  | { type: 'category'; categoryName: string }
  | { type: 'study'; mode: StudyMode; category: string; chunkIndex: number; cards: Card[]; isMix?: boolean }
  | { type: 'summary'; mode: StudyMode; category: string; chunkIndex: number; correct: Card[]; incorrect: Card[]; allCards: Card[]; isMix?: boolean }
  | { type: 'admin' }

export interface Card {
  id: string
  category: string
  order: number
  deck?: string
  english: string
  arabic: string
  transliteration: string
  accepted: string[]
  arabicVariants: string[]
  audio: { ar: string; en: string }
  tags: string[]
  notes: string
}

export interface CardProgress {
  cardId: string
  intervalDays: number
  easeFactor: number
  dueDate: string
  reps: number
  lapses: number
  lastReviewed: string | null
  // Mastery
  masteryStreak: number          // consecutive different-day correct sessions
  lastCorrectSession: string | null  // date string (toDateString) of last correct
  mastered: boolean              // auto: masteryStreak >= 5
  dismissed: boolean             // user clicked "don't show again"
  dismissedAt: string | null     // ISO date when dismissed (for weekly reset)
}

export type SRSGrade = 1 | 2 | 3 | 4
