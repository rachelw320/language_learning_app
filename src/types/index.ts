export type StudyMode = 'flashcard' | 'reverse' | 'listening' | 'speaking'

export type Screen = 'home' | 'study' | 'admin'

export interface Card {
  id: string
  deck: string
  english: string
  arabic: string
  transliteration: string
  accepted: string[]          // all accepted answer variants for fuzzy matching
  arabicVariants: string[]    // alternative Arabic spellings Whisper might return
  audio: {
    ar: string                // path to Egyptian Arabic audio
    en: string                // path to English audio
  }
  tags: string[]
  notes: string
}

// SM-2 spaced repetition progress per card per user
export interface CardProgress {
  cardId: string
  intervalDays: number        // days until next review
  easeFactor: number          // how easy (1.3–2.5+)
  dueDate: string             // ISO date string
  reps: number                // total successful reps
  lapses: number              // times forgotten
  lastReviewed: string | null
}

// 1=Again, 2=Hard, 3=Good, 4=Easy
export type SRSGrade = 1 | 2 | 3 | 4

export interface SpeakingResult {
  recognised: string
  score: number
  passed: boolean
  matchedVariant: string
}
