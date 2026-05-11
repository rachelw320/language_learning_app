import type { CardProgress } from '../types'
import { newCardProgress } from './srs'

const PROGRESS_KEY = 'ea_srs_progress'

export function loadProgress(): Record<string, CardProgress> {
  try { return JSON.parse(localStorage.getItem(PROGRESS_KEY) ?? '{}') }
  catch { return {} }
}

export function saveProgress(map: Record<string, CardProgress>) {
  localStorage.setItem(PROGRESS_KEY, JSON.stringify(map))
}

export function getOrCreate(map: Record<string, CardProgress>, cardId: string): CardProgress {
  return map[cardId] ?? newCardProgress(cardId)
}
