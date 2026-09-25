import type { CardProgress } from '../types'

const PROGRESS_KEY = 'ea_srs_progress'

export function loadProgress(): Record<string, CardProgress> {
  try { return JSON.parse(localStorage.getItem(PROGRESS_KEY) ?? '{}') }
  catch { return {} }
}

export function saveProgress(map: Record<string, CardProgress>) {
  localStorage.setItem(PROGRESS_KEY, JSON.stringify(map))
}
