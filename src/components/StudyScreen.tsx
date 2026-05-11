import { useState, useEffect, useRef, useCallback } from 'react'
import type { Card, CardProgress, StudyMode } from '../types'
import { supabase } from '../lib/supabase'
import { calculateNextReview, updateMastery, dismissCard, newCardProgress } from '../lib/srs'
import { loadProgress, saveProgress } from '../lib/progress'
import { checkAnswer, checkEnglish } from '../lib/fuzzyMatch'
import { playAudio } from './AudioButton'

interface Props {
  mode: StudyMode
  category: string
  chunkIndex: number
  cards: Card[]
  isMix?: boolean
  onBack: () => void
  onComplete: (correct: Card[], incorrect: Card[]) => void
}

type AnswerState = 'idle' | 'correct' | 'incorrect'

export default function StudyScreen({ mode, category: _cat, chunkIndex: _ci, cards, isMix: _isMix, onBack, onComplete }: Props) {
  const [extraCards, setExtraCards] = useState<Card[]>([])
  const allCards = [...cards, ...extraCards]

  const [index, setIndex] = useState(0)
  const [progress, setProgress] = useState<Record<string, CardProgress>>(loadProgress)
  const [correct, setCorrect] = useState<Card[]>([])
  const [incorrect, setIncorrect] = useState<Card[]>([])

  const [answer, setAnswer] = useState('')
  const [answerState, setAnswerState] = useState<AnswerState>('idle')
  const [matchScore, setMatchScore] = useState(0)

  const [searchQuery, setSearchQuery] = useState('')

  const inputRef = useRef<HTMLInputElement>(null)
  const card = allCards[index]

  const onCompleteRef = useRef(onComplete)
  onCompleteRef.current = onComplete
  const correctRef = useRef(correct)
  correctRef.current = correct
  const incorrectRef = useRef(incorrect)
  incorrectRef.current = incorrect

  // Fetch Supabase custom cards
  useEffect(() => {
    supabase.from('cards').select('*').then(({ data }) => {
      if (data && data.length > 0) {
        const custom: Card[] = data.map(row => ({
          id:              row.id,
          category:        'custom',
          order:           0,
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
        setExtraCards(custom)
      }
    })
  }, [])

  // Mode 1: autoplay English audio on new card
  useEffect(() => {
    if (mode !== 'flashcard' || !card) return
    playAudio(card.audio.en).catch(() => {})
  }, [index, card, mode])

  // Mode 2: autoplay Arabic audio on new card
  useEffect(() => {
    if (mode !== 'writing' || !card) return
    playAudio(card.audio.ar).catch(() => {})
  }, [index, card, mode])

  // Auto-focus input on new card
  useEffect(() => {
    if (mode === 'browse' || answerState !== 'idle') return
    const t = setTimeout(() => inputRef.current?.focus(), 120)
    return () => clearTimeout(t)
  }, [index, mode, answerState])

  // ── Progress helpers ────────────────────────────────────────────────────────

  const applyResult = useCallback((cardId: string, passed: boolean) => {
    setProgress(prev => {
      const existing: CardProgress = prev[cardId] ?? newCardProgress(cardId)
      const afterSRS = calculateNextReview(existing, passed ? 3 : 1)
      const afterMastery = updateMastery(afterSRS, passed)
      const next = { ...prev, [cardId]: afterMastery }
      saveProgress(next)
      return next
    })
  }, [])

  const handleDismiss = useCallback(() => {
    if (!card) return
    setProgress(prev => {
      const existing: CardProgress = prev[card.id] ?? newCardProgress(card.id)
      const next = { ...prev, [card.id]: dismissCard(existing) }
      saveProgress(next)
      return next
    })
  }, [card])

  // ── Navigation ─────────────────────────────────────────────────────────────

  const advance = useCallback((thisCard: Card, passed: boolean) => {
    const newCorrect   = passed  ? [...correctRef.current,   thisCard] : correctRef.current
    const newIncorrect = !passed ? [...incorrectRef.current, thisCard] : incorrectRef.current

    if (index >= allCards.length - 1) {
      onCompleteRef.current(newCorrect, newIncorrect)
      return
    }

    setCorrect(newCorrect)
    setIncorrect(newIncorrect)
    setIndex(i => i + 1)
    setAnswer('')
    setAnswerState('idle')
    setMatchScore(0)
  }, [index, allCards.length])

  // ── Check handlers ─────────────────────────────────────────────────────────

  const submitResult = (passed: boolean, score: number) => {
    applyResult(card.id, passed)
    setMatchScore(score)
    setAnswerState(passed ? 'correct' : 'incorrect')
    if (passed) {
      const snapshot = card
      setTimeout(() => advance(snapshot, true), 650)
    }
  }

  const handleCheckTranslit = () => {
    if (!answer.trim()) return
    const r = checkAnswer(answer.trim(), card.accepted, card.arabicVariants)
    submitResult(r.passed, r.score)
  }

  const handleCheckEnglish = () => {
    if (!answer.trim()) return
    const r = checkEnglish(answer.trim(), card.english)
    submitResult(r.passed, r.score)
  }

  const handleNext = () => {
    advance(card, false)
    setTimeout(() => inputRef.current?.focus(), 80)
  }

  const handleSkip = () => {
    if (index >= allCards.length - 1) {
      onCompleteRef.current(correctRef.current, incorrectRef.current)
      return
    }
    setAnswer('')
    setAnswerState('idle')
    setMatchScore(0)
    setIndex(i => i + 1)
  }

  // Is this card mastered (auto or via previous sessions)?
  const cardProgress = card ? progress[card.id] : undefined
  const isMastered = cardProgress?.mastered ?? false

  // ══════════════════════════════════════════════════════════════════════════
  // BROWSE MODE
  // ══════════════════════════════════════════════════════════════════════════

  if (mode === 'browse') {
    const filtered = searchQuery.trim()
      ? allCards.filter(c =>
          c.english.toLowerCase().includes(searchQuery.toLowerCase()) ||
          c.arabic.includes(searchQuery) ||
          c.transliteration.toLowerCase().includes(searchQuery.toLowerCase())
        )
      : allCards

    return (
      <div className="flex flex-col h-full safe-top">
        <div className="flex items-center justify-between px-5 pt-4 pb-3 border-b border-border flex-shrink-0">
          <button onClick={onBack} className="text-primary pressable text-sm font-medium">← Back</button>
          <span className="text-textSecondary text-sm font-medium">Browse</span>
          <span className="text-textSecondary text-xs">{filtered.length}</span>
        </div>
        <div className="px-4 pt-3 pb-2 flex-shrink-0">
          <input
            value={searchQuery}
            onChange={e => setSearchQuery(e.target.value)}
            placeholder="Search English, Arabic or transliteration…"
            className="w-full bg-surfaceHigh rounded-2xl px-4 py-3 text-white placeholder-textSecondary outline-none border border-transparent focus:border-primary transition-colors"
            style={{ fontSize: '16px' }}
          />
        </div>
        <div className="flex-1 overflow-y-auto px-4 py-2 space-y-2 safe-bottom">
          {filtered.map(c => (
            <div key={c.id} className="bg-surface border border-border rounded-2xl px-4 py-3.5 flex items-center gap-3">
              <div className="flex-1 min-w-0">
                <div className="flex items-baseline gap-3">
                  <p className="arabic-text text-white text-2xl leading-relaxed">{c.arabic}</p>
                  <p className="text-primary text-sm font-medium">{c.transliteration}</p>
                </div>
                <p className="text-textSecondary text-xs mt-0.5">{c.english}</p>
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
  // SHARED: Feedback panel (used by both typing modes)
  // ══════════════════════════════════════════════════════════════════════════

  const FeedbackPanel = ({ revealArabic }: { revealArabic: boolean }) => (
    <div className={`fade-in rounded-2xl px-5 py-4 border ${answerState === 'correct' ? 'border-success/40 bg-success/10' : 'border-danger/40 bg-danger/10'}`}>
      <div className="flex items-baseline gap-2 mb-2">
        <span className={`font-bold text-base ${answerState === 'correct' ? 'text-success' : 'text-danger'}`}>
          {answerState === 'correct' ? '✓ Correct!' : '✗ Not quite'}
        </span>
        {answerState === 'incorrect' && (
          <span className="text-textSecondary text-xs">{Math.round(matchScore * 100)}% match</span>
        )}
        {answerState === 'correct' && isMastered && (
          <span className="text-yellow-400 text-xs font-semibold">⭐ Mastered!</span>
        )}
      </div>

      {revealArabic ? (
        <>
          <p className="arabic-text text-white text-3xl leading-relaxed">{card.arabic}</p>
          <p className="text-primary text-base mt-1">{card.transliteration}</p>
        </>
      ) : (
        <p className="text-white text-xl font-semibold">{card.english}</p>
      )}

      {answerState === 'incorrect' && (
        <p className="text-textSecondary text-sm mt-2">
          You wrote: <span className="text-white">{answer}</span>
        </p>
      )}

      {/* Mastered — don't show again */}
      {answerState === 'correct' && isMastered && (
        <button
          onClick={handleDismiss}
          className="mt-3 text-xs text-textSecondary underline pressable"
        >
          Mastered · don't show again for a week
        </button>
      )}
    </div>
  )

  // ══════════════════════════════════════════════════════════════════════════
  // MODE 1: ENGLISH → ARABIC
  // ══════════════════════════════════════════════════════════════════════════

  if (mode === 'flashcard') {
    return (
      <div className="flex flex-col h-full safe-top">
        <div className="flex items-center justify-between px-5 pt-4 pb-3 border-b border-border flex-shrink-0">
          <button onClick={onBack} className="text-primary pressable text-sm font-medium">← Back</button>
          <span className="text-textSecondary text-sm font-medium">English → Arabic</span>
          <span className="text-textSecondary text-xs">{index + 1} / {allCards.length}</span>
        </div>

        <div className="flex-1 flex flex-col px-5 py-5 gap-4 overflow-y-auto">

          <div className="bg-surface border border-border rounded-3xl px-6 py-6 flex items-center justify-between gap-4" style={{ minHeight: '110px' }}>
            <p className="text-white text-2xl font-semibold leading-snug flex-1">{card.english}</p>
            <button
              onClick={() => playAudio(card.audio.en).catch(() => {})}
              className="w-11 h-11 rounded-full bg-surfaceHigh flex items-center justify-center flex-shrink-0 pressable"
              aria-label="Replay English"
            >
              <span className="text-lg">🔊</span>
            </button>
          </div>

          {answerState !== 'idle' && <FeedbackPanel revealArabic={true} />}

          {answerState === 'idle' && (
            <div className="space-y-3">
              <input
                ref={inputRef}
                value={answer}
                onChange={e => setAnswer(e.target.value)}
                onKeyDown={e => e.key === 'Enter' && answer.trim() && handleCheckTranslit()}
                placeholder="Type the transliteration…"
                autoCorrect="off"
                autoCapitalize="none"
                autoComplete="off"
                spellCheck={false}
                style={{ fontSize: '16px' }}
                className="w-full bg-surfaceHigh border border-transparent focus:border-primary rounded-2xl px-4 py-4 text-white placeholder-textSecondary outline-none transition-colors"
              />
              <button
                onClick={handleCheckTranslit}
                disabled={!answer.trim()}
                className="w-full bg-primary rounded-2xl py-4 text-white font-semibold pressable disabled:opacity-40"
              >
                Check
              </button>
            </div>
          )}

          {answerState === 'incorrect' && (
            <button onClick={handleNext} className="fade-in w-full bg-surfaceHigh border border-border rounded-2xl py-4 text-white font-semibold pressable">
              Next →
            </button>
          )}

          <button onClick={handleSkip} className="text-textSecondary text-sm text-center pressable py-2">Skip</button>
        </div>
      </div>
    )
  }

  // ══════════════════════════════════════════════════════════════════════════
  // MODE 2: ARABIC → ENGLISH
  // ══════════════════════════════════════════════════════════════════════════

  return (
    <div className="flex flex-col h-full safe-top">
      <div className="flex items-center justify-between px-5 pt-4 pb-3 border-b border-border flex-shrink-0">
        <button onClick={onBack} className="text-primary pressable text-sm font-medium">← Back</button>
        <span className="text-textSecondary text-sm font-medium">Arabic → English</span>
        <span className="text-textSecondary text-xs">{index + 1} / {allCards.length}</span>
      </div>

      <div className="flex-1 flex flex-col px-5 py-5 gap-4 overflow-y-auto">

        <div className="bg-surface border border-border rounded-3xl px-6 py-6" style={{ minHeight: '110px' }}>
          <div className="flex items-start justify-between gap-4">
            <div className="flex-1 min-w-0">
              <p className="arabic-text text-white text-4xl leading-relaxed">{card.arabic}</p>
              <p className="text-primary text-lg font-medium mt-2">{card.transliteration}</p>
            </div>
            <button
              onClick={() => playAudio(card.audio.ar).catch(() => {})}
              className="w-11 h-11 rounded-full bg-primary/20 flex items-center justify-center flex-shrink-0 pressable"
              aria-label="Replay Arabic"
            >
              <span className="text-lg">🔊</span>
            </button>
          </div>
        </div>

        {answerState !== 'idle' && <FeedbackPanel revealArabic={false} />}

        {answerState === 'idle' && (
          <div className="space-y-3">
            <input
              ref={inputRef}
              value={answer}
              onChange={e => setAnswer(e.target.value)}
              onKeyDown={e => e.key === 'Enter' && answer.trim() && handleCheckEnglish()}
              placeholder="Type the English meaning…"
              autoCorrect="off"
              autoCapitalize="none"
              autoComplete="off"
              spellCheck={false}
              style={{ fontSize: '16px' }}
              className="w-full bg-surfaceHigh border border-transparent focus:border-primary rounded-2xl px-4 py-4 text-white placeholder-textSecondary outline-none transition-colors"
            />
            <button
              onClick={handleCheckEnglish}
              disabled={!answer.trim()}
              className="w-full bg-primary rounded-2xl py-4 text-white font-semibold pressable disabled:opacity-40"
            >
              Check
            </button>
          </div>
        )}

        {answerState === 'incorrect' && (
          <button onClick={handleNext} className="fade-in w-full bg-surfaceHigh border border-border rounded-2xl py-4 text-white font-semibold pressable">
            Next →
          </button>
        )}

        <button onClick={handleSkip} className="text-textSecondary text-sm text-center pressable py-2">Skip</button>
      </div>
    </div>
  )
}
