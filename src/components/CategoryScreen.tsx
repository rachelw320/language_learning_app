import allCards from '../data/cards.json'
import type { Card, StudyMode } from '../types'
import {
  getCardsForCategory,
  isVerbCategory, getVerbGroups, getTagGroups, shuffle,
} from '../lib/chunks'
import { isDismissed } from '../lib/srs'
import { loadProgress } from '../lib/progress'

interface Props {
  categoryName: string
  onBack: () => void
  onStart: (mode: StudyMode, category: string, chunkIndex: number, cards: Card[], isMix?: boolean) => void
}

const allCardsTyped = allCards as Card[]

export default function CategoryScreen({ categoryName, onBack, onStart }: Props) {
  const progress = loadProgress()
  const rawCatCards = getCardsForCategory(allCardsTyped, categoryName)
  const catCards = rawCatCards.filter(c => !isDismissed(progress[c.id]))

  const isVerb = isVerbCategory(catCards)
  const verbGroups = isVerb ? getVerbGroups(catCards) : []
  const tagGroups = !isVerb ? getTagGroups(catCards) : []
  // Only show topic groups when there are multiple groups with real content
  const showTagGroups = tagGroups.length >= 2 && tagGroups.some(g => g.cards.length >= 2)

  const start = (mode: StudyMode, chunkIndex: number, cards: Card[], isMix?: boolean) => {
    onStart(mode, categoryName, chunkIndex, cards, isMix)
  }

  return (
    <div className="flex flex-col h-full safe-top safe-bottom">
      {/* Nav */}
      <div className="flex items-center justify-between px-5 pt-4 pb-3 border-b border-border flex-shrink-0">
        <button onClick={onBack} className="text-primary pressable text-sm font-medium">← Back</button>
        <span className="text-white text-sm font-semibold truncate px-2">{categoryName}</span>
        <span className="text-textSecondary text-xs">{catCards.length} cards</span>
      </div>

      <div className="flex-1 scroll-area px-5 py-5 space-y-5">

        {/* Study modes */}
        <div className="space-y-3">
          <p className="text-textSecondary text-xs font-medium uppercase tracking-wider px-1">Study mode</p>

          <button
            onClick={() => start('flashcard', 0, shuffle(catCards), true)}
            className="w-full bg-primary/10 border border-primary/20 rounded-3xl px-5 py-5 flex items-center gap-4 pressable text-left"
          >
            <div className="w-12 h-12 rounded-2xl bg-primary/20 flex items-center justify-center flex-shrink-0 text-2xl">🔊</div>
            <div className="flex-1 min-w-0">
              <p className="font-semibold text-white text-base">English → Arabic</p>
              <p className="text-primary/80 text-sm mt-0.5">Hear English · write the transliteration</p>
            </div>
            <span className="text-primary opacity-60 text-lg">›</span>
          </button>

          <button
            onClick={() => start('writing', 0, shuffle(catCards), true)}
            className="w-full bg-surface border border-border rounded-3xl px-5 py-5 flex items-center gap-4 pressable text-left"
          >
            <div className="w-12 h-12 rounded-2xl bg-success/15 flex items-center justify-center flex-shrink-0 text-2xl">✍️</div>
            <div className="flex-1 min-w-0">
              <p className="font-semibold text-white text-base">Arabic → English</p>
              <p className="text-textSecondary text-sm mt-0.5">See Arabic · write the meaning</p>
            </div>
            <span className="text-textTertiary text-lg">›</span>
          </button>

          <button
            onClick={() => start('browse', 0, catCards)}
            className="w-full bg-surface border border-border rounded-3xl px-5 py-5 flex items-center gap-4 pressable text-left"
          >
            <div className="w-12 h-12 rounded-2xl bg-surfaceHigh flex items-center justify-center flex-shrink-0 text-2xl">📋</div>
            <div className="flex-1 min-w-0">
              <p className="font-semibold text-white text-base">Browse</p>
              <p className="text-textSecondary text-sm mt-0.5">Search and explore all cards</p>
            </div>
            <span className="text-textTertiary text-lg">›</span>
          </button>

          {/* Fill in the Gaps — coming soon */}
          <div className="w-full bg-surface border border-border rounded-3xl px-5 py-5 flex items-center gap-4 opacity-40 cursor-not-allowed">
            <div className="w-12 h-12 rounded-2xl bg-surfaceHigh flex items-center justify-center flex-shrink-0 text-2xl">✏️</div>
            <div className="flex-1 min-w-0">
              <p className="font-semibold text-white text-base">Fill in the Gaps</p>
              <p className="text-textSecondary text-sm mt-0.5">Complete sentences · coming soon</p>
            </div>
            <span className="text-xs text-textTertiary bg-surfaceHigh rounded-lg px-2 py-1 flex-shrink-0">soon</span>
          </div>
        </div>

        {/* ── VERB GROUPS ───────────────────────────────────────────────────── */}
        {isVerb && (
          <div className="space-y-3">
            <div className="flex items-center justify-between px-1">
              <p className="text-textSecondary text-xs font-medium uppercase tracking-wider">By verb</p>
              <button
                onClick={() => start('flashcard', 0, shuffle(catCards), true)}
                className="flex items-center gap-1.5 bg-primary/10 border border-primary/20 rounded-xl px-3 py-1.5 text-primary text-xs font-semibold pressable"
              >
                🔀 Mix all
              </button>
            </div>

            <div className="space-y-2">
              {verbGroups.map(group => (
                <button
                  key={group.tag}
                  onClick={() => start('flashcard', 0, group.cards)}
                  className="w-full bg-surface border border-border rounded-2xl px-4 py-3.5 flex items-center gap-3 pressable text-left"
                >
                  <div className="flex-1 min-w-0">
                    <div className="flex items-baseline gap-2">
                      <p className="text-white text-sm font-semibold">{group.label}</p>
                      <p className="arabic-text text-primary text-lg leading-relaxed">{group.labelArabic}</p>
                    </div>
                    <p className="text-textSecondary text-xs mt-0.5">{group.cards.length} conjugations · present</p>
                  </div>
                  <span className="text-textTertiary text-lg">›</span>
                </button>
              ))}
            </div>
          </div>
        )}

        {/* ── TAG GROUPS (non-verb categories) ──────────────────────────────── */}
        {!isVerb && showTagGroups && (
          <div className="space-y-3">
            <div className="flex items-center justify-between px-1">
              <p className="text-textSecondary text-xs font-medium uppercase tracking-wider">By topic</p>
              <button
                onClick={() => start('flashcard', 0, shuffle(catCards), true)}
                className="flex items-center gap-1.5 bg-primary/10 border border-primary/20 rounded-xl px-3 py-1.5 text-primary text-xs font-semibold pressable"
              >
                🔀 Mix all
              </button>
            </div>

            <div className="space-y-2">
              {tagGroups.map(group => (
                <button
                  key={group.tag}
                  onClick={() => start('flashcard', 0, group.cards)}
                  className="w-full bg-surface border border-border rounded-2xl px-4 py-3.5 flex items-center gap-3 pressable text-left"
                >
                  <div className="flex-1 min-w-0">
                    <p className="text-white text-sm font-semibold">{group.label}</p>
                    <p className="text-textSecondary text-xs mt-0.5">{group.cards.length} cards</p>
                  </div>
                  <span className="text-textTertiary text-lg">›</span>
                </button>
              ))}
            </div>
          </div>
        )}

      </div>
    </div>
  )
}
