import { supabase } from './supabase'
import type { Card } from '../types'
import bundledCards from '../data/cards.json'

interface SupabaseRow {
  id: string
  category: string
  additional_categories: string[] | null
  order: number
  deck: string | null
  english: string
  arabic: string
  transliteration: string
  accepted: string[]
  arabic_variants: string[]
  audio: { ar: string; en: string }
  tags: string[]
  notes: string
}

function rowToCard(row: SupabaseRow): Card {
  return {
    id: row.id,
    category: row.category,
    additionalCategories: row.additional_categories?.length ? row.additional_categories : undefined,
    order: row.order,
    deck: row.deck ?? undefined,
    english: row.english,
    arabic: row.arabic,
    transliteration: row.transliteration,
    accepted: row.accepted,
    arabicVariants: row.arabic_variants,
    audio: row.audio,
    tags: row.tags,
    notes: row.notes,
  }
}

const CACHE_KEY = 'ea_cards_v2'

export function getInitialCards(): Card[] {
  try {
    const raw = localStorage.getItem(CACHE_KEY)
    if (raw) {
      const parsed = JSON.parse(raw) as Card[]
      if (parsed.length > 0) return parsed
    }
  } catch {}
  return bundledCards as Card[]
}

export async function fetchCardsFromSupabase(): Promise<Card[]> {
  const { data, error } = await supabase
    .from('cards')
    .select('*')
    .order('order', { ascending: true })

  if (error) throw error
  if (!data?.length) throw new Error('No cards returned from Supabase')

  const cards = (data as SupabaseRow[]).map(rowToCard)

  try {
    localStorage.setItem(CACHE_KEY, JSON.stringify(cards))
  } catch {}

  return cards
}
