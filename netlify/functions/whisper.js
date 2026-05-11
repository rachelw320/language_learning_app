/**
 * Netlify serverless function — proxies audio to OpenAI Whisper.
 * Keeps your OPENAI_API_KEY server-side only.
 *
 * Set OPENAI_API_KEY in: Netlify dashboard → Site settings → Environment variables
 */

import OpenAI from 'openai'
import { toFile } from 'openai'

export const config = { path: '/.netlify/functions/whisper' }

export default async function handler(req) {
  if (req.method !== 'POST') {
    return new Response('Method not allowed', { status: 405 })
  }

  try {
    const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY })

    const formData = await req.formData()
    const audioBlob = formData.get('file')

    if (!audioBlob) {
      return new Response(JSON.stringify({ error: 'No file provided' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    const arrayBuffer = await audioBlob.arrayBuffer()
    const buffer = Buffer.from(arrayBuffer)

    // Hint Arabic — Whisper handles Egyptian dialect well
    const transcription = await openai.audio.transcriptions.create({
      file: await toFile(buffer, 'recording.mp4', { type: 'audio/mp4' }),
      model: 'whisper-1',
      language: 'ar',
    })

    return new Response(JSON.stringify({ text: transcription.text }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    })
  } catch (err) {
    console.error('Whisper error:', err)
    return new Response(JSON.stringify({ error: 'Transcription failed' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    })
  }
}
