import type { Card } from '../types'

export const CHUNK_SIZE = 15

export function getCategories(cards: Card[]): string[] {
  const seen = new Set<string>()
  const result: string[] = []
  for (const c of cards) {
    if (!seen.has(c.category)) {
      seen.add(c.category)
      result.push(c.category)
    }
  }
  return result
}

export function getCardsForCategory(cards: Card[], category: string): Card[] {
  return cards.filter(c => c.category === category).sort((a, b) => a.order - b.order)
}

export function getChunkCount(cards: Card[]): number {
  return Math.ceil(cards.length / CHUNK_SIZE)
}

export function getChunk(cards: Card[], chunkIndex: number): Card[] {
  const start = chunkIndex * CHUNK_SIZE
  return cards.slice(start, start + CHUNK_SIZE)
}
