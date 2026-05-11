export type StudyMode = 'flashcard' | 'writing' | 'browse'

export type AppScreen =
  | { type: 'home' }
  | { type: 'category'; categoryName: string }
  | { type: 'study'; mode: StudyMode; category: string; chunkIndex: number; cards: Card[] }
  | { type: 'summary'; mode: StudyMode; category: string; chunkIndex: number; correct: Card[]; incorrect: Card[]; allCards: Card[] }
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
}

export type SRSGrade = 1 | 2 | 3 | 4
