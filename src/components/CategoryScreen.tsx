import allCards from '../data/cards.json'
import type { Card, StudyMode } from '../types'
import { getCardsForCategory, getChunk, getChunkCount } from '../lib/chunks'

interface Props {
  categoryName: string
  onBack: () => void
  onStart: (mode: StudyMode, category: string, chunkIndex: number, cards: Card[]) => void
}

const allCardsTyped = allCards as Card[]

export default function CategoryScreen({ categoryName, onBack, onStart }: Props) {
  const catCards = getCardsForCategory(allCardsTyped, categoryName)
  const chunkCount = getChunkCount(catCards)

  const start = (mode: StudyMode, chunkIndex: number) => {
    const chunk = getChunk(catCards, chunkIndex)
    onStart(mode, categoryName, chunkIndex, chunk)
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
            onClick={() => start('flashcard', 0)}
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
            onClick={() => start('writing', 0)}
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
            onClick={() => start('browse', 0)}
            className="w-full bg-surface border border-border rounded-3xl px-5 py-5 flex items-center gap-4 pressable text-left"
          >
            <div className="w-12 h-12 rounded-2xl bg-surfaceHigh flex items-center justify-center flex-shrink-0 text-2xl">📋</div>
            <div className="flex-1 min-w-0">
              <p className="font-semibold text-white text-base">Browse</p>
              <p className="text-textSecondary text-sm mt-0.5">Search and explore all cards</p>
            </div>
            <span className="text-textTertiary text-lg">›</span>
          </button>
        </div>

        {/* Chunk picker — only shown if more than one chunk */}
        {chunkCount > 1 && (
          <div className="space-y-3">
            <p className="text-textSecondary text-xs font-medium uppercase tracking-wider px-1">Jump to set</p>
            <div className="grid grid-cols-3 gap-2">
              {Array.from({ length: chunkCount }, (_, i) => (
                <button
                  key={i}
                  onClick={() => start('flashcard', i)}
                  className="bg-surface border border-border rounded-2xl py-3 px-2 flex flex-col items-center gap-0.5 pressable"
                >
                  <span className="text-white text-sm font-semibold">Set {i + 1}</span>
                  <span className="text-textSecondary text-xs">{getChunk(catCards, i).length} cards</span>
                </button>
              ))}
            </div>
            <p className="text-textTertiary text-xs text-center">Tap a set to start Flashcard mode for that set</p>
          </div>
        )}
      </div>
    </div>
  )
}
