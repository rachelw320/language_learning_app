import type { Card } from '../types'

export const CHUNK_SIZE = 15

function cardCategories(c: Card): string[] {
  return c.additionalCategories ? [c.category, ...c.additionalCategories] : [c.category]
}

export function getCategories(cards: Card[]): string[] {
  const seen = new Set<string>()
  const result: string[] = []
  for (const c of cards) {
    for (const cat of cardCategories(c)) {
      if (!seen.has(cat)) {
        seen.add(cat)
        result.push(cat)
      }
    }
  }
  return result
}

export function getCardsForCategory(cards: Card[], category: string): Card[] {
  return cards.filter(c => cardCategories(c).includes(category)).sort((a, b) => a.order - b.order)
}

export function getChunkCount(cards: Card[]): number {
  return Math.ceil(cards.length / CHUNK_SIZE)
}

export function getChunk(cards: Card[], chunkIndex: number): Card[] {
  const start = chunkIndex * CHUNK_SIZE
  return cards.slice(start, start + CHUNK_SIZE)
}

export function shuffle<T>(arr: T[]): T[] {
  const a = [...arr]
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1))
    ;[a[i], a[j]] = [a[j], a[i]]
  }
  return a
}

// ── Verb grouping ──────────────────────────────────────────────────────────────

export interface VerbGroup {
  tag: string           // e.g., "go"
  cards: Card[]         // all conjugations for this verb
  label: string         // citation form from "He" card, e.g., "beyerooh"
  labelArabic: string   // arabic from "He" card, e.g., "بيروح"
}

// A category is verb-grouped if its cards use the "verbs" primary tag
export function isVerbCategory(cards: Card[]): boolean {
  return cards.some(c => c.tags[0] === 'verbs')
}

export function getVerbGroups(cards: Card[]): VerbGroup[] {
  const groupMap = new Map<string, Card[]>()
  for (const c of cards) {
    const tag = c.tags[1] ?? 'other'
    if (!groupMap.has(tag)) groupMap.set(tag, [])
    groupMap.get(tag)!.push(c)
  }

  return Array.from(groupMap.entries()).map(([tag, groupCards]) => {
    const sorted = groupCards.sort((a, b) => a.order - b.order)
    // Use the "He" conjugation as the citation/display form
    const heCard = sorted.find(c => /^he\b/i.test(c.english))
    return {
      tag,
      cards: sorted,
      label: heCard?.transliteration ?? tag,
      labelArabic: heCard?.arabic ?? '',
    }
  })
}
