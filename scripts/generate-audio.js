/**
 * Generates the arabic and english mp3 for every card in src/data/cards.json using elevenlabs, into public/audio/.
 * Files that already exist are skipped, so it's safe to re-run after adding cards.
 *
 * Usage: npm run generate-audio
 * Needs ELEVENLABS_API_KEY and ELEVENLABS_ARABIC_VOICE_ID in .env
 */

import { config } from 'dotenv';
import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'fs';
import { dirname, join } from 'path';
import { fileURLToPath } from 'url';

config();

// Some networks (university wifi) swap in their own certificates, and node won't talk to elevenlabs through them without this
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

const ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');
const ARABIC_DIR = join(ROOT, 'public/audio/ar');
const ENGLISH_DIR = join(ROOT, 'public/audio/en');

const API_KEY = process.env.ELEVENLABS_API_KEY;
const ARABIC_VOICE_ID = process.env.ELEVENLABS_ARABIC_VOICE_ID;
// Elevenlabs' "Rachel" voice (no relation). Swap the id if you want a different english voice
const ENGLISH_VOICE_ID = '21m00Tcm4TlvDq8ikWAM';
const MODEL_ID = 'eleven_v3';
// Calm and consistent, no added drama
const VOICE_SETTINGS = { stability: 0.68, similarity_boost: 0.75, style: 0.0, use_speaker_boost: true };
// A short pause between cards so we don't hammer the api
const PAUSE_BETWEEN_CARDS_MS = 300;

if (!API_KEY || !ARABIC_VOICE_ID) {
	console.error('ELEVENLABS_API_KEY or ELEVENLABS_ARABIC_VOICE_ID is missing from .env :(');
	process.exit(1);
}

const cards = JSON.parse(readFileSync(join(ROOT, 'src/data/cards.json'), 'utf8'));
mkdirSync(ARABIC_DIR, { recursive: true });
mkdirSync(ENGLISH_DIR, { recursive: true });

/** Asks elevenlabs for an mp3 of the text and returns the bytes */
async function synthesise(text, voiceId) {
	const response = await fetch(`https://api.elevenlabs.io/v1/text-to-speech/${voiceId}`, {
		method: 'POST',
		headers: { 'xi-api-key': API_KEY, 'Content-Type': 'application/json', Accept: 'audio/mpeg' },
		body: JSON.stringify({ text, model_id: MODEL_ID, voice_settings: VOICE_SETTINGS }),
	});

	if (!response.ok) {
		throw new Error(`Elevenlabs said no (status ${response.status}): ${await response.text()}`);
	}

	return Buffer.from(await response.arrayBuffer());
}

/** Generates whichever of the card's two files don't exist yet and returns how many it made */
async function generateCard(card) {
	let made = 0;

	const arabicPath = join(ARABIC_DIR, `${card.id}.mp3`);
	if (!existsSync(arabicPath)) {
		writeFileSync(arabicPath, await synthesise(card.arabic, ARABIC_VOICE_ID));
		made++;
	}

	const englishPath = join(ENGLISH_DIR, `${card.id}.mp3`);
	if (!existsSync(englishPath)) {
		// The bracketed notes like "(to a man)" are for reading, not saying out loud
		const english = card.english.replace(/\s*\([^)]*\)/g, '').trim();
		writeFileSync(englishPath, await synthesise(english, ENGLISH_VOICE_ID));
		made++;
	}

	return made;
}

async function main() {
	console.log(`Generating audio for ${cards.length} cards`);
	let made = 0;
	let failed = 0;

	for (const card of cards) {
		try {
			const count = await generateCard(card);
			made += count;
			console.log(`${card.id}: ${count === 0 ? 'already done' : `${count} file${count === 1 ? '' : 's'} saved`}`);
			if (count > 0) {
				await new Promise((resolve) => setTimeout(resolve, PAUSE_BETWEEN_CARDS_MS));
			}
		} catch (error) {
			failed++;
			console.error(`${card.id}: ${error.message}`);
		}
	}

	console.log(`\nDone - ${made} files saved to public/audio/${failed ? `, ${failed} cards failed` : ''}`);
}

main();
