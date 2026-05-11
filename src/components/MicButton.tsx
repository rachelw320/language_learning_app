import { useState, useRef } from 'react'

interface Props {
  onResult: (transcript: string) => void
  onError?: (msg: string) => void
}

export default function MicButton({ onResult, onError }: Props) {
  const [recording, setRecording] = useState(false)
  const mediaRecorderRef = useRef<MediaRecorder | null>(null)
  const chunksRef = useRef<Blob[]>([])

  const startRecording = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true })

      // iOS Safari supports audio/mp4; other browsers support audio/webm
      const mimeType = MediaRecorder.isTypeSupported('audio/webm') ? 'audio/webm' : 'audio/mp4'
      const recorder = new MediaRecorder(stream, { mimeType })
      mediaRecorderRef.current = recorder
      chunksRef.current = []

      recorder.ondataavailable = e => { if (e.data.size > 0) chunksRef.current.push(e.data) }
      recorder.onstop = () => sendToWhisper(new Blob(chunksRef.current, { type: mimeType }))

      recorder.start()
      setRecording(true)
    } catch {
      onError?.('Microphone permission denied')
    }
  }

  const stopRecording = () => {
    mediaRecorderRef.current?.stop()
    mediaRecorderRef.current?.stream.getTracks().forEach(t => t.stop())
    setRecording(false)
  }

  const sendToWhisper = async (blob: Blob) => {
    try {
      const formData = new FormData()
      formData.append('file', blob, 'recording.mp4')

      const res = await fetch('/.netlify/functions/whisper', {
        method: 'POST',
        body: formData,
      })

      if (!res.ok) throw new Error('Whisper request failed')
      const { text } = await res.json() as { text: string }
      onResult(text.trim())
    } catch {
      onError?.('Could not process speech — try typing instead')
    }
  }

  return (
    <button
      onPointerDown={startRecording}
      onPointerUp={stopRecording}
      onPointerLeave={stopRecording}
      aria-label={recording ? 'Stop recording' : 'Hold to speak'}
      className={`w-24 h-24 rounded-full flex flex-col items-center justify-center gap-1 border-2 pressable transition-colors
        ${recording
          ? 'bg-danger border-danger mic-recording'
          : 'bg-surface border-border'
        }`}
    >
      <span className="text-3xl">{recording ? '⏹' : '🎤'}</span>
      <span className="text-xs text-textSecondary">{recording ? 'Release' : 'Hold'}</span>
    </button>
  )
}
