import type { Card } from '../types'
import { playAudio } from './AudioButton'

interface Props {
  card: Card
  isRevealed: boolean
  onTap?: () => void
}

export default function FlashCard({ card, isRevealed, onTap }: Props) {
  return (
    <div
      className="w-full bg-surface border border-border rounded-3xl px-7 py-8 flex flex-col cursor-pointer pressable"
      style={{ minHeight: '260px' }}
      onClick={!isRevealed ? onTap : undefined}
    >
      {!isRevealed ? (
        /* FRONT — English */
        <div className="flex flex-col h-full">
          <div className="flex justify-end">
            <button
              onClick={e => { e.stopPropagation(); playAudio(card.audio.en).catch(() => {}) }}
              className="w-11 h-11 rounded-full bg-surfaceHigh flex items-center justify-center pressable"
              aria-label="Replay English"
            >
              <span className="text-lg">🔊</span>
            </button>
          </div>
          <div className="flex-1 flex flex-col items-center justify-center gap-3">
            <p className="text-white text-2xl font-semibold text-center leading-snug">
              {card.english}
            </p>
          </div>
          <p className="text-textTertiary text-sm text-center mt-4">tap to reveal</p>
        </div>
      ) : (
        /* BACK — Arabic (fades in) */
        <div className="fade-in flex flex-col h-full">
          <div className="flex justify-end">
            <button
              onClick={() => playAudio(card.audio.ar).catch(() => {})}
              className="w-11 h-11 rounded-full bg-primary/20 flex items-center justify-center pressable"
              aria-label="Replay Arabic"
            >
              <span className="text-lg">🔊</span>
            </button>
          </div>
          <div className="flex-1 flex flex-col items-center justify-center gap-3">
            <p className="arabic-text text-white text-4xl text-center leading-relaxed">
              {card.arabic}
            </p>
            <p className="text-primary text-xl font-medium tracking-wide">
              {card.transliteration}
            </p>
          </div>
          <div className="flex items-center gap-3 mt-4">
            <div className="flex-1 h-px bg-border" />
            <p className="text-textSecondary text-sm">{card.english}</p>
            <div className="flex-1 h-px bg-border" />
          </div>
        </div>
      )}
    </div>
  )
}
