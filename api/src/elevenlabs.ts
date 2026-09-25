import type { AudioLanguage } from '../../shared/validation';

const ELEVENLABS_URL = 'https://api.elevenlabs.io/v1/text-to-speech';
// Elevenlabs' "Rachel" voice (no relation) for the english side. The arabic voice is set per deployment
const ENGLISH_VOICE_ID = '21m00Tcm4TlvDq8ikWAM';
const MODEL_ID = 'eleven_v3';
// Calm and consistent, no added drama
const VOICE_SETTINGS = { stability: 0.68, similarity_boost: 0.75, style: 0.0, use_speaker_boost: true };

export interface ElevenLabsConfig {
	apiKey: string;
	arabicVoiceId: string;
}

export type Synthesiser = (text: string, language: AudioLanguage) => Promise<ArrayBuffer>;

/** Returns a function that asks elevenlabs for an mp3 of some text */
export function createSynthesiser({ apiKey, arabicVoiceId }: ElevenLabsConfig): Synthesiser {
	return async (text, language) => {
		const voiceId = language === 'ar' ? arabicVoiceId : ENGLISH_VOICE_ID;
		const response = await fetch(`${ELEVENLABS_URL}/${voiceId}`, {
			method: 'POST',
			headers: { 'xi-api-key': apiKey, 'Content-Type': 'application/json', Accept: 'audio/mpeg' },
			body: JSON.stringify({ text, model_id: MODEL_ID, voice_settings: VOICE_SETTINGS }),
		});
		if (!response.ok) {
			throw new Error(`Elevenlabs said no (status ${response.status}): ${await response.text()}`);
		}
		return response.arrayBuffer();
	};
}
