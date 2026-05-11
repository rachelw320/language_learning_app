import { useState, useRef } from 'react'
import type { User } from '@supabase/supabase-js'
import { supabase } from '../lib/supabase'

interface Props {
  user: User
  onBack: () => void
}

type Lang = 'ar' | 'en'

export default function AdminScreen({ onBack }: Props) {
  const [english, setEnglish]   = useState('')
  const [arabic, setArabic]     = useState('')
  const [translit, setTranslit] = useState('')

  const [arBlob, setArBlob] = useState<Blob | null>(null)
  const [enBlob, setEnBlob] = useState<Blob | null>(null)

  const [recording,  setRecording]  = useState<Lang | null>(null)
  const [generating, setGenerating] = useState<Lang | null>(null)
  const [saving, setSaving]         = useState(false)
  const [saved,  setSaved]          = useState(false)
  const [error,  setError]          = useState('')

  const recorderRef = useRef<MediaRecorder | null>(null)
  const chunksRef   = useRef<Blob[]>([])

  const startRecording = async (lang: Lang) => {
    setError('')
    try {
      const stream   = await navigator.mediaDevices.getUserMedia({ audio: true })
      const mimeType = MediaRecorder.isTypeSupported('audio/webm') ? 'audio/webm' : 'audio/mp4'
      const recorder = new MediaRecorder(stream, { mimeType })
      recorderRef.current = recorder
      chunksRef.current   = []

      recorder.ondataavailable = e => { if (e.data.size > 0) chunksRef.current.push(e.data) }
      recorder.onstop = () => {
        const blob = new Blob(chunksRef.current, { type: mimeType })
        if (lang === 'ar') setArBlob(blob)
        else setEnBlob(blob)
        stream.getTracks().forEach(t => t.stop())
      }

      recorder.start()
      setRecording(lang)
    } catch {
      setError('Microphone permission denied')
    }
  }

  const stopRecording = () => {
    recorderRef.current?.stop()
    setRecording(null)
  }

  const generate = async (lang: Lang) => {
    const text = lang === 'ar'
      ? arabic.trim()
      : english.replace(/\s*\([^)]+\)/g, '').trim()

    if (!text) return
    setGenerating(lang)
    setError('')

    try {
      const res = await fetch('/.netlify/functions/tts', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ text, language: lang }),
      })
      if (!res.ok) throw new Error('TTS request failed')
      const blob = await res.blob()
      if (lang === 'ar') setArBlob(blob)
      else setEnBlob(blob)
    } catch {
      setError('Audio generation failed — are you on the deployed site?')
    } finally {
      setGenerating(null)
    }
  }

  const playBlob = (blob: Blob) => {
    const url   = URL.createObjectURL(blob)
    const audio = new Audio(url)
    audio.play()
    audio.onended = () => URL.revokeObjectURL(url)
  }

  const uploadAudio = async (blob: Blob, basePath: string): Promise<string> => {
    const ext      = blob.type.includes('webm') ? 'webm' : blob.type.includes('mpeg') ? 'mp3' : 'mp4'
    const fullPath = `${basePath}.${ext}`

    const { error: uploadError } = await supabase.storage
      .from('audio')
      .upload(fullPath, blob, { contentType: blob.type, upsert: true })

    if (uploadError) throw uploadError

    const { data } = supabase.storage.from('audio').getPublicUrl(fullPath)
    return data.publicUrl
  }

  const handleSave = async () => {
    if (!english.trim() || !arabic.trim() || !translit.trim()) {
      setError('English, Arabic and Transliteration are all required')
      return
    }

    setSaving(true)
    setError('')

    try {
      const id    = `card_${Date.now()}`
      const arUrl = arBlob ? await uploadAudio(arBlob, `ar/${id}`) : ''
      const enUrl = enBlob ? await uploadAudio(enBlob, `en/${id}`) : ''

      const { error: insertError } = await supabase.from('cards').insert({
        id,
        english:         english.trim(),
        arabic:          arabic.trim(),
        transliteration: translit.trim(),
        accepted:        [translit.trim()],
        arabic_variants: [arabic.trim()],
        audio_ar:        arUrl,
        audio_en:        enUrl,
      })

      if (insertError) throw insertError

      setEnglish('')
      setArabic('')
      setTranslit('')
      setArBlob(null)
      setEnBlob(null)
      setSaved(true)
      setTimeout(() => setSaved(false), 2000)
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : 'Save failed')
    } finally {
      setSaving(false)
    }
  }

  const canSave = english.trim() && arabic.trim() && translit.trim() && !saving

  return (
    <div className="flex flex-col h-full safe-top safe-bottom">
      {/* Nav */}
      <div className="flex items-center justify-between px-5 py-4 border-b border-border flex-shrink-0">
        <button onClick={onBack} className="text-primary pressable flex items-center gap-1">
          <span>←</span> <span className="text-sm">Back</span>
        </button>
        <span className="text-textSecondary text-sm">Add Card</span>
        <div className="w-12" />
      </div>

      <div className="flex-1 px-5 py-6 space-y-3 overflow-y-auto">

        {/* Text fields */}
        <input
          value={english}
          onChange={e => setEnglish(e.target.value)}
          placeholder="English"
          className="w-full bg-surface border border-border rounded-2xl px-4 py-3 text-textPrimary placeholder-textSecondary outline-none focus:border-primary"
        />
        <input
          value={arabic}
          onChange={e => setArabic(e.target.value)}
          placeholder="عربي"
          dir="rtl"
          lang="ar"
          className="w-full bg-surface border border-border rounded-2xl px-4 py-3 text-textPrimary placeholder-textSecondary outline-none focus:border-primary text-right"
        />
        <input
          value={translit}
          onChange={e => setTranslit(e.target.value)}
          placeholder="Transliteration"
          autoCorrect="off"
          autoCapitalize="none"
          autoComplete="off"
          spellCheck={false}
          className="w-full bg-surface border border-border rounded-2xl px-4 py-3 text-textPrimary placeholder-textSecondary outline-none focus:border-primary"
        />

        {/* Audio section */}
        <div className="pt-2">
          <p className="text-textSecondary text-xs uppercase tracking-wide mb-3">Audio</p>

          {(['ar', 'en'] as Lang[]).map(lang => {
            const blob      = lang === 'ar' ? arBlob : enBlob
            const isRec     = recording  === lang
            const isGen     = generating === lang
            const hasAudio  = blob !== null

            return (
              <div key={lang} className="flex items-center gap-2 mb-2">
                <span className="text-textSecondary text-sm font-medium w-7 uppercase">{lang}</span>

                {/* Record button — hold to record */}
                <button
                  onPointerDown={() => !isRec && startRecording(lang)}
                  onPointerUp={isRec ? stopRecording : undefined}
                  onPointerLeave={isRec ? stopRecording : undefined}
                  className={`flex-1 py-2.5 rounded-2xl text-sm font-medium pressable border transition-colors ${
                    isRec
                      ? 'bg-danger border-danger text-white'
                      : 'bg-surface border-border text-textPrimary'
                  }`}
                >
                  {isRec ? 'Release' : '🎤 Record'}
                </button>

                {/* Generate button */}
                <button
                  onClick={() => generate(lang)}
                  disabled={!!generating || (lang === 'ar' ? !arabic.trim() : !english.trim())}
                  className="flex-1 py-2.5 rounded-2xl text-sm font-medium pressable bg-surface border border-border text-textPrimary disabled:opacity-40"
                >
                  {isGen ? '…' : '✨ Generate'}
                </button>

                {/* Play preview */}
                {hasAudio && (
                  <button
                    onClick={() => playBlob(blob!)}
                    className="w-10 h-10 rounded-full bg-primary flex items-center justify-center pressable flex-shrink-0 text-white text-sm"
                  >
                    ▶
                  </button>
                )}
              </div>
            )
          })}
        </div>

        {error && (
          <p className="text-danger text-sm text-center">{error}</p>
        )}

        {/* Save */}
        <button
          onClick={handleSave}
          disabled={!canSave}
          className={`w-full py-4 rounded-2xl font-medium pressable transition-colors ${
            saved
              ? 'bg-success text-white'
              : 'bg-primary text-white disabled:opacity-40'
          }`}
        >
          {saved ? 'Saved!' : saving ? 'Saving…' : 'Save Card'}
        </button>
      </div>
    </div>
  )
}
