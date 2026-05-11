import type { Card, StudyMode } from '../types'
import AudioButton from './AudioButton'

interface Props {
  card: Card
  mode: StudyMode
  isRevealed: boolean
  onTap: () => void
}

export default function FlashCard({ card, mode, isRevealed, onTap }: Props) {
  const showArabicFirst = mode === 'reverse' || mode === 'listening'

  return (
    <div className="card-scene w-full" style={{ minHeight: '300px' }}>
      <div className={`card-body ${isRevealed ? 'is-flipped' : ''}`} style={{ minHeight: '300px' }}>

        {/* ── FRONT FACE ─────────────────────────────────── */}
        <div
          className="card-face w-full bg-surface border border-border rounded-3xl p-7 flex flex-col items-center justify-center gap-5 cursor-pointer"
          style={{ minHeight: '300px' }}
          onClick={onTap}
        >
          {mode === 'listening' ? (
            /* Listening mode: show only the audio button */
            <div className="flex flex-col items-center gap-4">
              <AudioButton src={card.audio.ar} size="lg" label="Play Arabic audio" />
              <p className="text-textSecondary text-sm">What does this mean?</p>
            </div>
          ) : showArabicFirst ? (
            /* Reverse mode: show Arabic + transliteration */
            <div className="flex flex-col items-center gap-4 w-full">
              <AudioButton src={card.audio.ar} size="md" label="Play Arabic" />
              <p className="arabic-text text-3xl text-center text-white leading-relaxed">{card.arabic}</p>
              <p className="text-primary text-xl font-medium tracking-wide">{card.transliteration}</p>
              <p className="text-textTertiary text-sm mt-2">Tap to reveal English</p>
            </div>
          ) : (
            /* Flashcard mode: show English */
            <div className="flex flex-col items-center gap-5 w-full">
              <AudioButton src={card.audio.en} size="md" label="Play English" />
              <p className="text-white text-2xl font-medium text-center leading-snug">{card.english}</p>
              <p className="text-textTertiary text-sm mt-2">Tap to reveal Arabic</p>
            </div>
          )}
        </div>

        {/* ── BACK FACE ──────────────────────────────────── */}
        <div
          className="card-face-back w-full bg-surface border border-border rounded-3xl p-7 flex flex-col items-center justify-center gap-5 cursor-pointer"
          style={{ minHeight: '300px' }}
          onClick={onTap}
        >
          {showArabicFirst ? (
            /* Back of reverse/listening: reveal English */
            <div className="flex flex-col items-center gap-4 w-full">
              <AudioButton src={card.audio.en} size="md" label="Play English" />
              <p className="text-white text-2xl font-medium text-center leading-snug">{card.english}</p>
              <div className="w-full h-px bg-border my-1" />
              <p className="arabic-text text-2xl text-textSecondary text-center">{card.arabic}</p>
              <p className="text-primary text-lg tracking-wide">{card.transliteration}</p>
            </div>
          ) : (
            /* Back of flashcard: reveal Arabic */
            <div className="flex flex-col items-center gap-4 w-full">
              <AudioButton src={card.audio.ar} size="md" label="Play Arabic" />
              <p className="arabic-text text-3xl text-center text-white leading-relaxed">{card.arabic}</p>
              <p className="text-primary text-xl font-medium tracking-wide">{card.transliteration}</p>
              <div className="w-full h-px bg-border my-1" />
              <p className="text-textSecondary text-base text-center">{card.english}</p>
            </div>
          )}
        </div>

      </div>
    </div>
  )
}
