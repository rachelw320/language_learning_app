import type { Card, StudyMode } from '../types'
import { getCardsForCategory, getChunk, getChunkCount } from '../lib/chunks'
import { playAudio } from './AudioButton'

interface Props {
  cards: Card[]
  mode: StudyMode
  category: string
  chunkIndex: number
  correct: Card[]
  incorrect: Card[]
  allCards: Card[]
  isMix?: boolean
  onRetry: () => void
  onReviewWrong: () => void
  onNextSet: (chunkIndex: number, cards: Card[]) => void
  onBack: () => void
}

export default function SummaryScreen({
  cards,
  mode,
  category,
  chunkIndex,
  correct,
  incorrect,
  allCards: sessionCards,
  isMix,
  onRetry,
  onReviewWrong,
  onNextSet,
  onBack,
}: Props) {
  const total = sessionCards.length
  const score = total > 0 ? Math.round((correct.length / total) * 100) : 0
  const passed = score >= 80

  const catCards = getCardsForCategory(cards, category)
  const totalChunks = getChunkCount(catCards)
  const hasNextSet = !isMix && chunkIndex + 1 < totalChunks
  const nextChunkCards = hasNextSet ? getChunk(catCards, chunkIndex + 1) : []

  const modeLabel = mode === 'flashcard' ? 'English → Arabic' : mode === 'writing' ? 'Arabic → English' : 'Browse'
  const sessionLabel = isMix ? 'Mix' : `Set ${chunkIndex + 1}`

  return (
    <div className="flex flex-col h-full safe-top safe-bottom">
      {/* Nav */}
      <div className="flex items-center justify-between px-5 pt-4 pb-3 border-b border-border flex-shrink-0">
        <button onClick={onBack} className="text-primary pressable text-sm font-medium">← Back</button>
        <span className="text-textSecondary text-sm font-medium">{modeLabel} · {sessionLabel}</span>
        <span className="text-textSecondary text-xs">{category}</span>
      </div>

      <div className="flex-1 overflow-y-auto px-5 py-6 space-y-5">

        {/* Score circle */}
        <div className="flex flex-col items-center gap-2 py-4">
          <div className={`w-24 h-24 rounded-full flex items-center justify-center border-4 ${passed ? 'border-success bg-success/10' : 'border-danger bg-danger/10'}`}>
            <span className={`text-3xl font-bold ${passed ? 'text-success' : 'text-danger'}`}>{score}%</span>
          </div>
          <p className="text-white font-semibold text-lg">{passed ? 'Great work!' : 'Keep practising'}</p>
          <div className="flex gap-4 mt-1">
            <span className="text-success text-sm font-medium">✓ {correct.length} correct</span>
            <span className="text-danger text-sm font-medium">✗ {incorrect.length} incorrect</span>
          </div>
        </div>

        {/* Actions */}
        <div className="space-y-3">
          {incorrect.length > 0 && (
            <button
              onClick={onReviewWrong}
              className="w-full bg-danger/10 border border-danger/30 rounded-2xl py-4 text-danger font-semibold pressable"
            >
              Review {incorrect.length} incorrect card{incorrect.length !== 1 ? 's' : ''}
            </button>
          )}

          {hasNextSet && (
            <button
              onClick={() => onNextSet(chunkIndex + 1, nextChunkCards)}
              className="w-full bg-primary rounded-2xl py-4 text-white font-semibold pressable"
            >
              Next set → Set {chunkIndex + 2}
            </button>
          )}

          <button
            onClick={onRetry}
            className="w-full bg-surface border border-border rounded-2xl py-4 text-white font-semibold pressable"
          >
            Retry this set
          </button>

          <button
            onClick={onBack}
            className="w-full text-textSecondary text-sm text-center pressable py-2"
          >
            Back to category
          </button>
        </div>

        {/* Incorrect card list */}
        {incorrect.length > 0 && (
          <div className="space-y-2">
            <p className="text-textSecondary text-xs font-medium uppercase tracking-wider px-1">Missed cards</p>
            {incorrect.map(c => (
              <div
                key={c.id}
                className="bg-surface border border-border rounded-2xl px-4 py-3.5 flex items-center gap-3"
              >
                <div className="flex-1 min-w-0">
                  <div className="flex items-baseline gap-2 flex-wrap">
                    <p className="arabic-text text-white text-2xl leading-relaxed">{c.arabic}</p>
                    <p className="text-primary text-sm font-medium">{c.transliteration}</p>
                  </div>
                  <p className="text-textSecondary text-xs mt-0.5">{c.english}</p>
                </div>
                <button
                  onClick={() => playAudio(c.audio.ar).catch(() => {})}
                  className="w-9 h-9 rounded-full bg-surfaceHigh flex items-center justify-center flex-shrink-0 pressable"
                  aria-label="Play Arabic"
                >
                  <span className="text-primary text-sm">▶</span>
                </button>
              </div>
            ))}
          </div>
        )}

      </div>
    </div>
  )
}
