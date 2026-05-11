import { useState, useEffect, useRef } from 'react'
import type { Card, CardProgress, StudyMode } from '../types'
import { supabase } from '../lib/supabase'
import { calculateNextReview, newCardProgress } from '../lib/srs'
import { checkAnswer } from '../lib/fuzzyMatch'
import { playAudio } from './AudioButton'
import FlashCard from './FlashCard'
import allCards from '../data/cards.json'

const PROGRESS_KEY = 'ea_srs_progress'

function loadProgress(): Record<string, CardProgress> {
  try { return JSON.parse(localStorage.getItem(PROGRESS_KEY) ?? '{}') }
  catch { return {} }
}

function saveProgress(map: Record<string, CardProgress>) {
  localStorage.setItem(PROGRESS_KEY, JSON.stringify(map))
}

interface Props {
  mode: StudyMode
  onBack: () => void
}

type AnswerMode = 'translit' | 'arabic'

interface SpeakResult {
  passed: boolean
  score: number
  recognised: string
}

export default function StudyScreen({ mode, onBack }: Props) {
  const [cards, setCards] = useState<Card[]>(allCards as Card[])
  const [index, setIndex] = useState(0)
  const [isRevealed, setIsRevealed] = useState(false)
  const [progress, setProgress] = useState<Record<string, CardProgress>>(loadProgress)

  // Speaking mode
  const [answerMode, setAnswerMode] = useState<AnswerMode>('translit')
  const [answer, setAnswer] = useState('')
  const [speakResult, setSpeakResult] = useState<SpeakResult | null>(null)

  // Browse mode
  const [searchQuery, setSearchQuery] = useState('')

  const inputRef = useRef<HTMLInputElement>(null)
  const card = cards[index]

  // Merge custom Supabase cards
  useEffect(() => {
    supabase.from('cards').select('*').then(({ data }) => {
      if (data && data.length > 0) {
        const custom: Card[] = data.map(row => ({
          id:              row.id,
          deck:            'custom',
          english:         row.english,
          arabic:          row.arabic,
          transliteration: row.transliteration,
          accepted:        row.accepted ?? [row.transliteration],
          arabicVariants:  row.arabic_variants ?? [row.arabic],
          audio:           { ar: row.audio_ar ?? '', en: row.audio_en ?? '' },
          tags:            [],
          notes:           '',
        }))
        setCards([...(allCards as Card[]), ...custom])
      }
    })
  }, [])

  // Flashcard: autoplay English audio when new card appears
  useEffect(() => {
    if (mode !== 'flashcard' || !card) return
    playAudio(card.audio.en).catch(() => {})
  }, [index, card, mode])

  // Speaking: auto-focus input on new card (and mode switch)
  useEffect(() => {
    if (mode !== 'speaking' || speakResult) return
    const t = setTimeout(() => inputRef.current?.focus(), 120)
    return () => clearTimeout(t)
  }, [index, mode, speakResult, answerMode])

  // ── SRS helpers ────────────────────────────────────────────────────────────

  const applyGrade = (passed: boolean) => {
    const existing = progress[card.id] ?? newCardProgress(card.id)
    const updated = calculateNextReview(existing, passed ? 3 : 1)
    const next = { ...progress, [card.id]: updated }
    setProgress(next)
    saveProgress(next)
  }

  // ── Navigation ─────────────────────────────────────────────────────────────

  const nextCard = () => {
    setIsRevealed(false)
    setAnswer('')
    setSpeakResult(null)
    setIndex(i => (i + 1) % cards.length)
  }

  // ── Flashcard handlers ─────────────────────────────────────────────────────

  const handleReveal = () => {
    setIsRevealed(true)
    playAudio(card.audio.ar).catch(() => {})
  }

  const handleGrade = (passed: boolean) => {
    applyGrade(passed)
    nextCard()
  }

  // ── Speaking handlers ──────────────────────────────────────────────────────

  const handleCheck = () => {
    if (!answer.trim()) return
    const r = checkAnswer(answer.trim(), card.accepted, card.arabicVariants)
    setSpeakResult({ passed: r.passed, score: r.score, recognised: answer.trim() })
    playAudio(card.audio.ar).catch(() => {})
    applyGrade(r.passed)
  }

  const handleNext = () => {
    nextCard()
    setTimeout(() => inputRef.current?.focus(), 80)
  }

  const switchAnswerMode = (m: AnswerMode) => {
    setAnswerMode(m)
    setAnswer('')
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BROWSE MODE
  // ══════════════════════════════════════════════════════════════════════════

  if (mode === 'browse') {
    const filtered = searchQuery.trim()
      ? cards.filter(c =>
          c.english.toLowerCase().includes(searchQuery.toLowerCase()) ||
          c.arabic.includes(searchQuery) ||
          c.transliteration.toLowerCase().includes(searchQuery.toLowerCase())
        )
      : cards

    return (
      <div className="flex flex-col h-full safe-top">
        {/* Nav */}
        <div className="flex items-center justify-between px-5 pt-4 pb-3 border-b border-border flex-shrink-0">
          <button onClick={onBack} className="text-primary pressable text-sm font-medium">
            ← Back
          </button>
          <span className="text-textSecondary text-sm font-medium">All terms</span>
          <span className="text-textSecondary text-xs">{filtered.length}</span>
        </div>

        {/* Search */}
        <div className="px-4 pt-3 pb-2 flex-shrink-0">
          <input
            value={searchQuery}
            onChange={e => setSearchQuery(e.target.value)}
            placeholder="Search..."
            className="w-full bg-surfaceHigh rounded-2xl px-4 py-3 text-white placeholder-textSecondary outline-none border border-transparent focus:border-primary transition-colors"
          />
        </div>

        {/* List */}
        <div className="flex-1 overflow-y-auto px-4 py-2 space-y-2 safe-bottom">
          {filtered.map(c => (
            <div
              key={c.id}
              className="bg-surface border border-border rounded-2xl px-4 py-3.5 flex items-center gap-3"
            >
              <div className="flex-1 min-w-0">
                <p className="text-white text-sm font-medium">{c.english}</p>
                <p className="arabic-text text-primary text-xl mt-1">{c.arabic}</p>
                <p className="text-textSecondary text-xs mt-0.5">{c.transliteration}</p>
              </div>
              <button
                onClick={() => playAudio(c.audio.ar).catch(() => {})}
                className="w-10 h-10 rounded-full bg-surfaceHigh flex items-center justify-center flex-shrink-0 pressable"
                aria-label="Play Arabic"
              >
                <span className="text-primary text-base">▶</span>
              </button>
            </div>
          ))}
        </div>
      </div>
    )
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SPEAKING MODE
  // ══════════════════════════════════════════════════════════════════════════

  if (mode === 'speaking') {
    return (
      <div className="flex flex-col h-full safe-top">
        {/* Nav */}
        <div className="flex items-center justify-between px-5 pt-4 pb-3 border-b border-border flex-shrink-0">
          <button onClick={onBack} className="text-primary pressable text-sm font-medium">← Back</button>
          <span className="text-textSecondary text-sm font-medium">Speaking</span>
          <span className="text-textSecondary text-xs">{index + 1} / {cards.length}</span>
        </div>

        <div className="flex-1 flex flex-col px-5 py-5 gap-4 overflow-y-auto">

          {/* English prompt */}
          <div className="bg-surface border border-border rounded-3xl px-6 py-7 flex items-center justify-center" style={{ minHeight: '110px' }}>
            <p className="text-white text-2xl font-semibold text-center leading-snug">{card.english}</p>
          </div>

          {/* Result after submit */}
          {speakResult && (
            <div className={`fade-in rounded-2xl px-5 py-4 border ${speakResult.passed ? 'border-success/40 bg-success/10' : 'border-danger/40 bg-danger/10'}`}>
              <div className="flex items-baseline gap-2 mb-2">
                <span className={`font-bold text-base ${speakResult.passed ? 'text-success' : 'text-danger'}`}>
                  {speakResult.passed ? '✓ Correct!' : '✗ Not quite'}
                </span>
                {!speakResult.passed && (
                  <span className="text-textSecondary text-xs">{Math.round(speakResult.score * 100)}% match</span>
                )}
              </div>
              <p className="arabic-text text-white text-2xl">{card.arabic}</p>
              <p className="text-primary text-base mt-1">{card.transliteration}</p>
              {!speakResult.passed && (
                <p className="text-textSecondary text-sm mt-2">
                  You wrote: <span className="text-white">{speakResult.recognised}</span>
                </p>
              )}
            </div>
          )}

          {/* Input (before submit) */}
          {!speakResult && (
            <div className="space-y-3">
              {/* Mode toggle */}
              <div className="flex bg-surfaceHigh rounded-2xl p-1 gap-1">
                <button
                  onClick={() => switchAnswerMode('translit')}
                  className={`flex-1 py-2.5 rounded-xl text-sm font-medium transition-colors ${answerMode === 'translit' ? 'bg-primary text-white' : 'text-textSecondary'}`}
                >
                  Transliteration
                </button>
                <button
                  onClick={() => switchAnswerMode('arabic')}
                  className={`flex-1 py-2.5 rounded-xl text-sm font-medium transition-colors ${answerMode === 'arabic' ? 'bg-primary text-white' : 'text-textSecondary'}`}
                >
                  Arabic عربي
                </button>
              </div>

              {/* Text input */}
              <input
                ref={inputRef}
                value={answer}
                onChange={e => setAnswer(e.target.value)}
                onKeyDown={e => e.key === 'Enter' && answer.trim() && handleCheck()}
                placeholder={answerMode === 'arabic' ? 'اكتب هنا…' : 'e.g. bte3mel eh…'}
                dir={answerMode === 'arabic' ? 'rtl' : 'ltr'}
                lang={answerMode === 'arabic' ? 'ar' : 'en'}
                autoCorrect="off"
                autoCapitalize="none"
                autoComplete="off"
                spellCheck={false}
                className={`w-full bg-surfaceHigh border border-transparent focus:border-primary rounded-2xl px-4 py-4 text-white placeholder-textSecondary outline-none transition-colors ${answerMode === 'arabic' ? 'text-right text-xl' : 'text-base'}`}
              />

              <button
                onClick={handleCheck}
                disabled={!answer.trim()}
                className="w-full bg-primary rounded-2xl py-4 text-white font-semibold pressable disabled:opacity-40"
              >
                Check
              </button>
            </div>
          )}

          {/* Next button after result */}
          {speakResult && (
            <button
              onClick={handleNext}
              className="fade-in w-full bg-surfaceHigh border border-border rounded-2xl py-4 text-white font-semibold pressable"
            >
              Next →
            </button>
          )}

          <button onClick={nextCard} className="text-textSecondary text-sm text-center pressable py-2">
            Skip
          </button>

        </div>
      </div>
    )
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FLASHCARD MODE
  // ══════════════════════════════════════════════════════════════════════════

  return (
    <div className="flex flex-col h-full safe-top">
      {/* Nav */}
      <div className="flex items-center justify-between px-5 pt-4 pb-3 border-b border-border flex-shrink-0">
        <button onClick={onBack} className="text-primary pressable text-sm font-medium">← Back</button>
        <span className="text-textSecondary text-sm font-medium">Flashcard</span>
        <span className="text-textSecondary text-xs">{index + 1} / {cards.length}</span>
      </div>

      <div className="flex-1 flex flex-col items-center px-5 py-6 gap-5 overflow-y-auto">

        {/* Card */}
        <div className="w-full max-w-sm flex-1 flex items-center justify-center">
          <div className="w-full">
            <FlashCard
              card={card}
              isRevealed={isRevealed}
              onTap={handleReveal}
            />
          </div>
        </div>

        {/* Bottom controls */}
        <div className="w-full max-w-sm space-y-3 flex-shrink-0 pb-2">
          {!isRevealed && (
            <button
              onClick={handleReveal}
              className="w-full bg-surface border border-border rounded-2xl py-4 text-textSecondary font-medium pressable"
            >
              Reveal
            </button>
          )}

          {isRevealed && (
            <div className="slide-up grid grid-cols-2 gap-3">
              <button
                onClick={() => handleGrade(false)}
                className="bg-danger/15 border border-danger/30 rounded-2xl py-4 text-danger font-semibold text-base pressable"
              >
                ✗  Missed it
              </button>
              <button
                onClick={() => handleGrade(true)}
                className="bg-success/15 border border-success/30 rounded-2xl py-4 text-success font-semibold text-base pressable"
              >
                ✓  Got it
              </button>
            </div>
          )}

          <button onClick={nextCard} className="w-full text-textSecondary text-sm text-center pressable py-2">
            Skip
          </button>
        </div>

      </div>
    </div>
  )
}
