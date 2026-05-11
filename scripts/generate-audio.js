/**
 * generate-audio.js
 *
 * Generates Egyptian Arabic and English audio for every card using ElevenLabs.
 * Run once: npm run generate-audio
 *
 * Requires in .env:
 *   ELEVENLABS_API_KEY
 *   ELEVENLABS_ARABIC_VOICE_ID   (your Egyptian Arabic voice)
 */

// Needed on networks with custom SSL certificates (e.g. university proxies)
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0'

import { readFileSync, writeFileSync, mkdirSync, existsSync } from 'fs'
import { join, dirname } from 'path'
import { fileURLToPath } from 'url'
import { config } from 'dotenv'

config()

const __dirname = dirname(fileURLToPath(import.meta.url))
const ROOT = join(__dirname, '..')

const API_KEY        = process.env.ELEVENLABS_API_KEY
const ARABIC_VOICE   = process.env.ELEVENLABS_ARABIC_VOICE_ID

// ElevenLabs voice for English — "Rachel" is a clear, natural English voice
// Replace this ID if you want a different English voice
const ENGLISH_VOICE  = '21m00Tcm4TlvDq8ikWAM'

if (!API_KEY || !ARABIC_VOICE) {
  console.error('❌  Missing ELEVENLABS_API_KEY or ELEVENLABS_ARABIC_VOICE_ID in .env')
  process.exit(1)
}

const cards = JSON.parse(readFileSync(join(ROOT, 'src/data/cards.json'), 'utf-8'))

// Ensure audio output directories exist
const arDir = join(ROOT, 'public/audio/ar')
const enDir = join(ROOT, 'public/audio/en')
mkdirSync(arDir, { recursive: true })
mkdirSync(enDir, { recursive: true })

/**
 * Call ElevenLabs TTS and return MP3 bytes.
 * Uses eleven_multilingual_v2 — handles Egyptian Arabic dialect well.
 */
async function synthesise(text, voiceId) {
  const url = `https://api.elevenlabs.io/v1/text-to-speech/${voiceId}`

  const res = await fetch(url, {
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
        stability: 0.68,          // higher = calmer, more consistent delivery
        similarity_boost: 0.75,
        style: 0.0,               // 0 = no added drama or enthusiasm
        use_speaker_boost: true,
      },
    }),
  })

  if (!res.ok) {
    const err = await res.text()
    throw new Error(`ElevenLabs error ${res.status}: ${err}`)
  }

  return Buffer.from(await res.arrayBuffer())
}

async function generateCard(card) {
  const arPath = join(arDir, `${card.id}.mp3`)
  const enPath = join(enDir, `${card.id}.mp3`)

  // Arabic audio
  if (existsSync(arPath)) {
    process.stdout.write(`  ✓ ${card.id} ar  already exists\n`)
  } else {
    const audio = await synthesise(card.arabic, ARABIC_VOICE)
    writeFileSync(arPath, audio)
    process.stdout.write(`  🎙  ${card.id} ar  → saved\n`)
  }

  // English audio — strip gender notes in brackets e.g. "(to a man)"
  if (existsSync(enPath)) {
    process.stdout.write(`  ✓ ${card.id} en  already exists\n`)
  } else {
    const enText = card.english.replace(/\s*\([^)]+\)/g, '').trim()
    const audio = await synthesise(enText, ENGLISH_VOICE)
    writeFileSync(enPath, audio)
    process.stdout.write(`  🎙  ${card.id} en  → saved\n`)
  }
}

async function main() {
  console.log(`\n🎙  Generating audio for ${cards.length} cards via ElevenLabs…\n`)

  for (const card of cards) {
    try {
      await generateCard(card)
      // Small delay so we don't hammer the API
      await new Promise(r => setTimeout(r, 300))
    } catch (err) {
      console.error(`  ❌  ${card.id}: ${err.message}`)
    }
  }

  console.log(`\n✅  Done — audio saved to public/audio/`)
  console.log(`    Run "npm run dev" to hear it in the app.\n`)
}

main()
