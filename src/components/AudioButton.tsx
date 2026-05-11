import { useState } from 'react'

interface Props {
  src: string
  label?: string
  size?: 'sm' | 'md' | 'lg'
}

// A simple reusable audio button.
// We use a shared Audio element strategy to work around iOS audio unlock.
let unlockedAudio: HTMLAudioElement | null = null

export function playAudio(src: string): Promise<void> {
  return new Promise((resolve, reject) => {
    if (!unlockedAudio) {
      unlockedAudio = new Audio()
    }
    unlockedAudio.src = src
    unlockedAudio.load()
    unlockedAudio.onended = () => resolve()
    unlockedAudio.onerror = () => reject(new Error('Audio failed'))
    unlockedAudio.play().catch(reject)
  })
}

export default function AudioButton({ src, label, size = 'md' }: Props) {
  const [playing, setPlaying] = useState(false)

  const sizeClasses = {
    sm: 'w-10 h-10 text-lg',
    md: 'w-14 h-14 text-2xl',
    lg: 'w-20 h-20 text-3xl',
  }

  const handlePlay = async () => {
    if (playing) return
    setPlaying(true)
    try {
      await playAudio(src)
    } catch {
      // Audio file may not exist yet (before generate-audio runs)
    } finally {
      setPlaying(false)
    }
  }

  return (
    <button
      onClick={handlePlay}
      aria-label={label ?? 'Play audio'}
      className={`${sizeClasses[size]} rounded-full bg-surface border border-border flex items-center justify-center pressable`}
    >
      {playing ? (
        <span className="text-primary">▐▐</span>
      ) : (
        <span>🔊</span>
      )}
    </button>
  )
}
