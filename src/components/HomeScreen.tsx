import type { StudyMode } from '../types'
import cards from '../data/cards.json'

interface Props {
  onStartStudy: (mode: StudyMode) => void
  onAdmin: () => void
}

export default function HomeScreen({ onStartStudy, onAdmin }: Props) {
  return (
    <div className="flex flex-col h-full safe-top safe-bottom">
      {/* Header */}
      <div className="flex items-center justify-between px-5 py-4 border-b border-border flex-shrink-0">
        <div>
          <h1 className="text-lg font-semibold text-white">Egyptian Arabic</h1>
          <p className="text-textSecondary text-xs mt-0.5">{cards.length} cards · Essentials</p>
        </div>
        <button
          onClick={onAdmin}
          className="w-9 h-9 rounded-full bg-surfaceHigh flex items-center justify-center text-primary text-xl pressable leading-none"
          aria-label="Manage cards"
        >
          +
        </button>
      </div>

      {/* Modes */}
      <div className="flex-1 scroll-area px-5 py-6 space-y-3">

        {/* Flashcard — primary */}
        <button
          onClick={() => onStartStudy('flashcard')}
          className="w-full bg-primary/10 border border-primary/20 rounded-3xl px-5 py-5 flex items-center gap-4 pressable text-left"
        >
          <div className="w-12 h-12 rounded-2xl bg-primary/20 flex items-center justify-center flex-shrink-0 text-2xl">
            🃏
          </div>
          <div className="flex-1 min-w-0">
            <p className="font-semibold text-white text-base">Flashcard</p>
            <p className="text-primary/80 text-sm mt-0.5">English → hear & reveal Arabic</p>
          </div>
          <span className="text-primary opacity-60 text-lg">›</span>
        </button>

        {/* Speaking */}
        <button
          onClick={() => onStartStudy('speaking')}
          className="w-full bg-surface border border-border rounded-3xl px-5 py-5 flex items-center gap-4 pressable text-left"
        >
          <div className="w-12 h-12 rounded-2xl bg-success/15 flex items-center justify-center flex-shrink-0 text-2xl">
            ✍️
          </div>
          <div className="flex-1 min-w-0">
            <p className="font-semibold text-white text-base">Speaking</p>
            <p className="text-textSecondary text-sm mt-0.5">Type or dictate your answer</p>
          </div>
          <span className="text-textTertiary text-lg">›</span>
        </button>

        {/* Browse */}
        <button
          onClick={() => onStartStudy('browse')}
          className="w-full bg-surface border border-border rounded-3xl px-5 py-5 flex items-center gap-4 pressable text-left"
        >
          <div className="w-12 h-12 rounded-2xl bg-surfaceHigh flex items-center justify-center flex-shrink-0 text-2xl">
            📋
          </div>
          <div className="flex-1 min-w-0">
            <p className="font-semibold text-white text-base">Browse all terms</p>
            <p className="text-textSecondary text-sm mt-0.5">Search, listen, explore</p>
          </div>
          <span className="text-textTertiary text-lg">›</span>
        </button>

      </div>
    </div>
  )
}
