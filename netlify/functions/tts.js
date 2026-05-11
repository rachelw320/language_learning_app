/**
 * Netlify function — proxies text to ElevenLabs TTS.
 * Keeps ELEVENLABS_API_KEY server-side only.
 */

process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0'

const ARABIC_VOICE  = process.env.ELEVENLABS_ARABIC_VOICE_ID
const ENGLISH_VOICE = '21m00Tcm4TlvDq8ikWAM'
const API_KEY       = process.env.ELEVENLABS_API_KEY

export default async function handler(req) {
  if (req.method !== 'POST') {
    return new Response('Method not allowed', { status: 405 })
  }

  try {
    const { text, language } = await req.json()
    if (!text || !language) {
      return new Response(JSON.stringify({ error: 'Missing text or language' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    const voiceId = language === 'ar' ? ARABIC_VOICE : ENGLISH_VOICE

    const res = await fetch(`https://api.elevenlabs.io/v1/text-to-speech/${voiceId}`, {
      method: 'POST',
      headers: {
        'xi-api-key': API_KEY,
        'Content-Type': 'application/json',
        'Accept': 'audio/mpeg',
      },
      body: JSON.stringify({
        text,
        model_id: 'eleven_v3',
        voice_settings: {
          stability: 0.68,
          similarity_boost: 0.75,
          style: 0.0,
          use_speaker_boost: true,
        },
      }),
    })

    if (!res.ok) {
      const err = await res.text()
      return new Response(JSON.stringify({ error: err }), {
        status: res.status,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    const buffer = Buffer.from(await res.arrayBuffer())
    return new Response(buffer, {
      status: 200,
      headers: { 'Content-Type': 'audio/mpeg' },
    })
  } catch (err) {
    console.error('TTS error:', err)
    return new Response(JSON.stringify({ error: 'TTS failed' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    })
  }
}
