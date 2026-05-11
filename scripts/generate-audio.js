/**
 * generate-audio.js
 *
 * Generates Egyptian Arabic (ar-EG) and English audio for every card.
 * Run once: npm run generate-audio
 *
 * Requires: AZURE_SPEECH_KEY and AZURE_SPEECH_REGION in .env
 */

import { readFileSync, writeFileSync, mkdirSync, existsSync } from 'fs'
import { join, dirname } from 'path'
import { fileURLToPath } from 'url'
import { config } from 'dotenv'

config()

const __dirname = dirname(fileURLToPath(import.meta.url))
const ROOT = join(__dirname, '..')

const KEY    = process.env.AZURE_SPEECH_KEY
const REGION = process.env.AZURE_SPEECH_REGION ?? 'uksouth'

if (!KEY) {
  console.error('❌  Missing AZURE_SPEECH_KEY in .env')
  process.exit(1)
}

const cards = JSON.parse(readFileSync(join(ROOT, 'src/data/cards.json'), 'utf-8'))

// Ensure audio output directories exist
const arDir = join(ROOT, 'public/audio/ar')
const enDir = join(ROOT, 'public/audio/en')
mkdirSync(arDir, { recursive: true })
mkdirSync(enDir, { recursive: true })

/**
 * Call Azure TTS REST API and return raw MP3 bytes.
 * Voice ar-EG-SalmaNeural is specifically Egyptian Arabic dialect.
 */
async function synthesise(text, locale, voice) {
  const ssml = `
<speak version="1.0" xml:lang="${locale}">
  <voice name="${voice}">
    <prosody rate="0%" pitch="0%">${text}</prosody>
  </voice>
</speak>`.trim()

  const url = `https://${REGION}.tts.speech.microsoft.com/cognitiveservices/v1`

  const res = await fetch(url, {
    method: 'POST',
    headers: {
      'Ocp-Apim-Subscription-Key': KEY,
      'Content-Type': 'application/ssml+xml',
      'X-Microsoft-OutputFormat': 'audio-16khz-128kbitrate-mono-mp3',
    },
    body: ssml,
  })

  if (!res.ok) {
    const err = await res.text()
    throw new Error(`Azure TTS error ${res.status}: ${err}`)
  }

  return Buffer.from(await res.arrayBuffer())
}

async function generateCard(card) {
  const arPath = join(arDir, `${card.id}.mp3`)
  const enPath = join(enDir, `${card.id}.mp3`)

  // Skip if already generated
  if (existsSync(arPath) && existsSync(enPath)) {
    console.log(`  ✓ ${card.id} already exists — skipping`)
    return
  }

  // Egyptian Arabic audio
  if (!existsSync(arPath)) {
    const arAudio = await synthesise(
      card.arabic,
      'ar-EG',
      'ar-EG-SalmaNeural'  // Egyptian Arabic female — change to ar-EG-ShakirNeural for male
    )
    writeFileSync(arPath, arAudio)
    console.log(`  🎙  ${card.id} Arabic  → ${arPath}`)
  }

  // English audio
  if (!existsSync(enPath)) {
    // Use a clean English description (strip gender notes in brackets)
    const enText = card.english.replace(/\s*\([^)]+\)/g, '').trim()
    const enAudio = await synthesise(
      enText,
      'en-US',
      'en-US-JennyNeural'
    )
    writeFileSync(enPath, enAudio)
    console.log(`  🎙  ${card.id} English → ${enPath}`)
  }
}

async function main() {
  console.log(`\n🎙  Generating audio for ${cards.length} cards using Azure TTS (${REGION})…\n`)
  let generated = 0
  let skipped = 0

  for (const card of cards) {
    try {
      const arPath = join(arDir, `${card.id}.mp3`)
      const enPath = join(enDir, `${card.id}.mp3`)
      const alreadyDone = existsSync(arPath) && existsSync(enPath)

      await generateCard(card)

      if (alreadyDone) skipped++
      else generated++

      // Small delay to be polite to the Azure API
      await new Promise(r => setTimeout(r, 150))
    } catch (err) {
      console.error(`  ❌  ${card.id}: ${err.message}`)
    }
  }

  console.log(`\n✅  Done — ${generated} generated, ${skipped} skipped`)
  console.log(`    Audio files saved to public/audio/`)
  console.log(`    Run "npm run build" to include them in the site.\n`)
}

main()
