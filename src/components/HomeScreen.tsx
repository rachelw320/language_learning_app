import type { StudyMode } from '../types'
import cards from '../data/cards.json'

interface Props {
  onStartStudy: (mode: StudyMode) => void
  onAdmin: () => void
}

const MODES: { id: StudyMode; label: string; description: string; icon: string }[] = [
  {
    id: 'browse',
    label: 'See all terms',
    description: 'Browse every card in the deck',
    icon: '📋',
  },
  {
    id: 'flashcard',
    label: 'Flashcard',
    description: 'See English → reveal Arabic',
    icon: '🃏',
  },
  {
    id: 'write',
    label: 'Write',
    description: 'See English → write Arabic',
    icon: '✍️',
  },
  {
    id: 'reverse',
    label: 'Reverse',
    description: 'See Arabic → reveal English',
    icon: '🔄',
  },
  {
    id: 'listening',
    label: 'Listening',
    description: 'Hear Arabic → guess meaning',
    icon: '👂',
  },
  {
    id: 'speaking',
    label: 'Speaking',
    description: 'See English → type Arabic',
    icon: '🎤',
  },
]

export default function HomeScreen({ onStartStudy, onAdmin }: Props) {
  return (
    <div className="flex flex-col h-full safe-top safe-bottom">
      {/* Header */}
      <div className="flex items-center justify-between px-5 py-4 border-b border-border">
        <div>
          <div className="text-lg font-semibold">Egyptian Arabic</div>
          <div className="text-textSecondary text-xs">{cards.length} cards</div>
        </div>
        <button
          onClick={onAdmin}
          className="text-primary text-2xl pressable leading-none"
          aria-label="Add card"
        >
          +
        </button>
      </div>

      {/* Content */}
      <div className="flex-1 scroll-area px-5 py-6 space-y-6">
        {/* Deck card */}
        <div className="bg-surface rounded-3xl p-5 border border-border">
          <div className="text-xs text-textSecondary uppercase tracking-wider font-medium mb-2">Current deck</div>
          <div className="text-xl font-semibold">Essentials</div>
          <div className="text-textSecondary text-sm mt-1">Core phrases for daily conversation</div>
        </div>

        {/* Study modes */}
        <div>
          <div className="text-textSecondary text-xs uppercase tracking-wider font-medium mb-3 px-1">
            Study modes
          </div>
          <div className="space-y-2">
            {MODES.map(mode => (
              <button
                key={mode.id}
                onClick={() => onStartStudy(mode.id)}
                className="w-full bg-surface border border-border rounded-3xl px-5 py-4 flex items-center gap-4 pressable text-left"
              >
                <span className="text-2xl">{mode.icon}</span>
                <div className="flex-1 min-w-0">
                  <div className="font-semibold text-base">{mode.label}</div>
                  <div className="text-textSecondary text-sm truncate">{mode.description}</div>
                </div>
                <svg className="w-5 h-5 text-textTertiary flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                </svg>
              </button>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}
