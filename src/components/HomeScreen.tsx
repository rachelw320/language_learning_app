import type { Card } from '../types'
import { getCategories, getCardsForCategory } from '../lib/chunks'
import { loadProgress } from '../lib/progress'

interface Props {
  cards: Card[]
  onCategory: (name: string) => void
  onAdmin: () => void
}

const CATEGORY_EMOJI: Record<string, string> = {
  'Top 50 Essentials': '⭐',
  'Core Verbs': '🔤',
}

const RECENT_COUNT = 6

export default function HomeScreen({ cards, onCategory, onAdmin }: Props) {
  const categories = getCategories(cards)
  const progress = loadProgress()

  // Mastery stats
  const totalCards = cards.length
  const masteredCount = cards.filter(c => progress[c.id]?.mastered).length
  const masteryPct = totalCards > 0 ? Math.round((masteredCount / totalCards) * 100) : 0

  // Recent words — cards sorted by lastReviewed descending, take top N
  const recentCards = cards
    .filter(c => progress[c.id]?.lastReviewed)
    .sort((a, b) => {
      const aTime = new Date(progress[a.id].lastReviewed!).getTime()
      const bTime = new Date(progress[b.id].lastReviewed!).getTime()
      return bTime - aTime
    })
    .slice(0, RECENT_COUNT)

  return (
    <div className="flex flex-col h-full safe-top safe-bottom">
      {/* Header */}
      <div className="flex items-center justify-between px-5 py-4 border-b border-border flex-shrink-0">
        <div>
          <h1 className="text-lg font-semibold text-white">Egyptian Arabic</h1>
          <p className="text-textSecondary text-xs mt-0.5">{totalCards} cards · {categories.length} categories</p>
        </div>
        <button
          onClick={onAdmin}
          className="w-9 h-9 rounded-full bg-surfaceHigh flex items-center justify-center text-primary text-xl pressable leading-none"
          aria-label="Manage cards"
        >
          +
        </button>
      </div>

      <div className="flex-1 scroll-area px-5 py-5 space-y-5">

        {/* Mastery progress bar */}
        <div className="bg-surface border border-border rounded-2xl px-4 py-4">
          <div className="flex items-baseline justify-between mb-2">
            <p className="text-white text-sm font-semibold">Mastery</p>
            <p className="text-textSecondary text-xs">{masteredCount} / {totalCards} mastered</p>
          </div>
          <div className="w-full h-2 bg-surfaceHigh rounded-full overflow-hidden">
            <div
              className="h-full bg-primary rounded-full transition-all"
              style={{ width: `${masteryPct}%` }}
            />
          </div>
          <p className="text-textSecondary text-xs mt-1.5">{masteryPct}% · 5 correct sessions to master a card</p>
        </div>

        {/* Recent words */}
        {recentCards.length > 0 && (
          <div className="space-y-2">
            <p className="text-textSecondary text-xs font-medium uppercase tracking-wider px-1">Recently studied</p>
            <div className="grid grid-cols-2 gap-2">
              {recentCards.map(c => {
                const p = progress[c.id]
                const streak = p?.masteryStreak ?? 0
                return (
                  <div key={c.id} className="bg-surface border border-border rounded-2xl px-3 py-2.5">
                    <p className="arabic-text text-white text-xl leading-relaxed">{c.arabic}</p>
                    <p className="text-textSecondary text-xs mt-0.5 truncate">{c.english}</p>
                    <div className="flex gap-0.5 mt-1.5">
                      {Array.from({ length: 5 }, (_, i) => (
                        <div
                          key={i}
                          className={`h-1 flex-1 rounded-full ${i < streak ? 'bg-primary' : 'bg-surfaceHigh'}`}
                        />
                      ))}
                    </div>
                  </div>
                )
              })}
            </div>
          </div>
        )}

        {/* Category list */}
        <div className="space-y-3">
          <p className="text-textSecondary text-xs font-medium uppercase tracking-wider px-1">Categories</p>
          {categories.map((cat, i) => {
            const catCards = getCardsForCategory(cards, cat)
            const catMastered = catCards.filter(c => progress[c.id]?.mastered).length
            const catPct = catCards.length > 0 ? Math.round((catMastered / catCards.length) * 100) : 0
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
                    {catCards.length} cards · {catPct}% mastered
                  </p>
                </div>
                <span className={`text-lg ${isPrimary ? 'text-primary opacity-60' : 'text-textTertiary'}`}>›</span>
              </button>
            )
          })}
        </div>

      </div>
    </div>
  )
}
