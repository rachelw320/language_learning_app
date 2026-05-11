import allCards from '../data/cards.json'
import type { Card } from '../types'
import { getCategories, getCardsForCategory } from '../lib/chunks'

interface Props {
  onCategory: (name: string) => void
  onAdmin: () => void
}

const cards = allCards as Card[]

const CATEGORY_EMOJI: Record<string, string> = {
  'Top 50 Essentials': '⭐',
  'Core Verbs': '🔤',
}

export default function HomeScreen({ onCategory, onAdmin }: Props) {
  const categories = getCategories(cards)

  return (
    <div className="flex flex-col h-full safe-top safe-bottom">
      {/* Header */}
      <div className="flex items-center justify-between px-5 py-4 border-b border-border flex-shrink-0">
        <div>
          <h1 className="text-lg font-semibold text-white">Egyptian Arabic</h1>
          <p className="text-textSecondary text-xs mt-0.5">{cards.length} cards · {categories.length} categories</p>
        </div>
        <button
          onClick={onAdmin}
          className="w-9 h-9 rounded-full bg-surfaceHigh flex items-center justify-center text-primary text-xl pressable leading-none"
          aria-label="Manage cards"
        >
          +
        </button>
      </div>

      {/* Category list */}
      <div className="flex-1 scroll-area px-5 py-6 space-y-3">
        {categories.map((cat, i) => {
          const catCards = getCardsForCategory(cards, cat)
          const emoji = CATEGORY_EMOJI[cat] ?? '📚'
          const isPrimary = i === 0
          return (
            <button
              key={cat}
              onClick={() => onCategory(cat)}
              className={`w-full rounded-3xl px-5 py-5 flex items-center gap-4 pressable text-left ${
                isPrimary
                  ? 'bg-primary/10 border border-primary/20'
                  : 'bg-surface border border-border'
              }`}
            >
              <div className={`w-12 h-12 rounded-2xl flex items-center justify-center flex-shrink-0 text-2xl ${
                isPrimary ? 'bg-primary/20' : 'bg-surfaceHigh'
              }`}>
                {emoji}
              </div>
              <div className="flex-1 min-w-0">
                <p className="font-semibold text-white text-base">{cat}</p>
                <p className={`text-sm mt-0.5 ${isPrimary ? 'text-primary/80' : 'text-textSecondary'}`}>
                  {catCards.length} cards
                </p>
              </div>
              <span className={`text-lg ${isPrimary ? 'text-primary opacity-60' : 'text-textTertiary'}`}>›</span>
            </button>
          )
        })}
      </div>
    </div>
  )
}
