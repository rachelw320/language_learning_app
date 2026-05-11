import { useState, useEffect, useCallback } from 'react'
import type { User } from '@supabase/supabase-js'
import type { Card, CardProgress, StudyMode, SRSGrade, SpeakingResult } from '../types'
import { supabase } from '../lib/supabase'
import { calculateNextReview, newCardProgress } from '../lib/srs'
import { checkAnswer } from '../lib/fuzzyMatch'
import { playAudio } from './AudioButton'
import FlashCard from './FlashCard'
import SRSButtons from './SRSButtons'
import MicButton from './MicButton'
import allCards from '../data/cards.json'

interface Props {
  user: User
  mode: StudyMode
  onBack: () => void
}

type UIState = 'front' | 'revealed' | 'graded'

export default function StudyScreen({ user, mode, onBack }: Props) {
  const [cards] = useState<Card[]>(allCards as Card[])
  const [index, setIndex] = useState(0)
  const [uiState, setUiState] = useState<UIState>('front')
  const [progress, setProgress] = useState<Record<string, CardProgress>>({})
  const [typedAnswer, setTypedAnswer] = useState('')
  const [speakingResult, setSpeakingResult] = useState<SpeakingResult | null>(null)
  const [speakingError, setSpeakingError] = useState('')

  const card = cards[index]

  // Load SRS progress from Supabase on mount
  useEffect(() => {
    supabase
      .from('user_progress')
      .select('*')
      .eq('user_id', user.id)
      .then(({ data }) => {
        if (data) {
          const map: Record<string, CardProgress> = {}
          for (const row of data) {
            map[row.card_id] = {
              cardId: row.card_id,
              intervalDays: row.interval_days,
              easeFactor: row.ease_factor,
              dueDate: row.due_date,
              reps: row.reps,
              lapses: row.lapses,
              lastReviewed: row.last_reviewed,
            }
          }
          setProgress(map)
        }
      })
  }, [user.id])

  const saveProgress = useCallback(async (updated: CardProgress) => {
    await supabase.from('user_progress').upsert({
      user_id: user.id,
      card_id: updated.cardId,
      interval_days: updated.intervalDays,
      ease_factor: updated.easeFactor,
      due_date: updated.dueDate,
      reps: updated.reps,
      lapses: updated.lapses,
      last_reviewed: updated.lastReviewed,
    }, { onConflict: 'user_id,card_id' })
  }, [user.id])

  const handleReveal = async () => {
    setUiState('revealed')
    // Auto-play the answer audio after revealing
    const audioSrc = (mode === 'reverse' || mode === 'listening')
      ? card.audio.en
      : card.audio.ar
    try { await playAudio(audioSrc) } catch { /* file may not exist yet */ }
  }

  const handleGrade = async (grade: SRSGrade) => {
    const existing = progress[card.id] ?? newCardProgress(card.id)
    const updated = calculateNextReview(existing, grade)
    setProgress(prev => ({ ...prev, [card.id]: updated }))
    await saveProgress(updated)
    nextCard()
  }

  const nextCard = () => {
    setUiState('front')
    setTypedAnswer('')
    setSpeakingResult(null)
    setSpeakingError('')
    setIndex(i => (i + 1) % cards.length)
  }

  const handleSpeakingCheck = (input: string) => {
    const result = checkAnswer(input, card.accepted, card.arabicVariants)
    setSpeakingResult(result)
    if (result.passed) {
      setUiState('revealed')
      playAudio(card.audio.ar).catch(() => {})
    }
  }

  const modeLabel: Record<StudyMode, string> = {
    flashcard: 'Flashcard',
    reverse: 'Reverse',
    listening: 'Listening',
    speaking: 'Speaking',
  }

  return (
    <div className="flex flex-col h-full safe-top safe-bottom">
      {/* Nav bar */}
      <div className="flex items-center justify-between px-5 py-4 border-b border-border flex-shrink-0">
        <button onClick={onBack} className="text-primary pressable flex items-center gap-1">
          <span>←</span> <span className="text-sm">Back</span>
        </button>
        <span className="text-textSecondary text-sm">{modeLabel[mode]}</span>
        <span className="text-textSecondary text-xs">{index + 1} / {cards.length}</span>
      </div>

      {/* Main content */}
      <div className="flex-1 flex flex-col items-center justify-between px-5 py-6 gap-6 scroll-area">

        {/* Card */}
        <div className="w-full max-w-sm">
          <FlashCard
            card={card}
            mode={mode}
            isRevealed={uiState !== 'front'}
            onTap={uiState === 'front' ? handleReveal : () => {}}
          />
        </div>

        {/* Bottom section */}
        <div className="w-full max-w-sm space-y-4 flex-shrink-0">

          {/* SPEAKING MODE controls */}
          {mode === 'speaking' && uiState === 'front' && (
            <div className="flex flex-col items-center gap-4">
              <MicButton
                onResult={handleSpeakingCheck}
                onError={msg => setSpeakingError(msg)}
              />
              {speakingError && (
                <p className="text-textSecondary text-sm text-center">{speakingError}</p>
              )}

              {/* Typing fallback */}
              <div className="w-full flex gap-2">
                <input
                  value={typedAnswer}
                  onChange={e => setTypedAnswer(e.target.value)}
                  onKeyDown={e => e.key === 'Enter' && handleSpeakingCheck(typedAnswer)}
                  placeholder="Or type transliteration…"
                  className="flex-1 bg-surface border border-border rounded-2xl px-4 py-3 text-textPrimary placeholder-textSecondary text-sm outline-none focus:border-primary"
                />
                <button
                  onClick={() => handleSpeakingCheck(typedAnswer)}
                  disabled={!typedAnswer.trim()}
                  className="bg-primary rounded-2xl px-4 text-white font-medium pressable disabled:opacity-40"
                >
                  Check
                </button>
              </div>

              {speakingResult && !speakingResult.passed && (
                <div className="text-center space-y-1">
                  <p className="text-danger text-sm">Not quite — try again</p>
                  <p className="text-textSecondary text-xs">
                    Match: {Math.round(speakingResult.score * 100)}%
                  </p>
                  <button
                    onClick={() => { setUiState('revealed'); playAudio(card.audio.ar).catch(() => {}) }}
                    className="text-textSecondary text-xs underline pressable"
                  >
                    Show answer
                  </button>
                </div>
              )}
              {speakingResult?.passed && (
                <p className="text-success text-sm font-medium text-center">
                  ✓ Correct! ({Math.round(speakingResult.score * 100)}% match)
                </p>
              )}
            </div>
          )}

          {/* Reveal button for non-speaking modes */}
          {mode !== 'speaking' && uiState === 'front' && (
            <button
              onClick={handleReveal}
              className="w-full bg-surface border border-border rounded-2xl py-4 text-white font-medium pressable"
            >
              Tap to reveal
            </button>
          )}

          {/* SRS grading (shown after reveal) */}
          {uiState === 'revealed' && (
            <SRSButtons onGrade={handleGrade} />
          )}

          {/* Skip button */}
          <button
            onClick={nextCard}
            className="w-full text-textSecondary text-sm pressable py-1"
          >
            Skip →
          </button>
        </div>
      </div>
    </div>
  )
}
