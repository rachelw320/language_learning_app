/**
 * Netlify function that turns text into speech with elevenlabs. The admin screen calls it so the api key
 * never has to be in the browser. POST { text, language: 'ar' | 'en' } and you get an mp3 back
 */

const ELEVENLABS_URL = 'https://api.elevenlabs.io/v1/text-to-speech';
// Elevenlabs' "Rachel" voice (no relation) for the english side. The arabic voice is set per deployment
const ENGLISH_VOICE_ID = '21m00Tcm4TlvDq8ikWAM';
const MODEL_ID = 'eleven_v3';
// Calm and consistent, no added drama
const VOICE_SETTINGS = { stability: 0.68, similarity_boost: 0.75, style: 0.0, use_speaker_boost: true };

function jsonResponse(status, body) {
	return new Response(JSON.stringify(body), { status, headers: { 'Content-Type': 'application/json' } });
}

export default async function handler(request) {
	if (request.method !== 'POST') {
		return jsonResponse(405, { error: 'Only POST works here' });
	}

	const apiKey = process.env.ELEVENLABS_API_KEY;
	const arabicVoiceId = process.env.ELEVENLABS_ARABIC_VOICE_ID;
	if (!apiKey || !arabicVoiceId) {
		return jsonResponse(500, { error: 'ELEVENLABS_API_KEY or ELEVENLABS_ARABIC_VOICE_ID is missing from the netlify env vars :(' });
	}

	try {
		const { text, language } = await request.json();
		if (!text || !language) {
			return jsonResponse(400, { error: "No text or language sent, can't do much without them :(" });
		}

		const voiceId = language === 'ar' ? arabicVoiceId : ENGLISH_VOICE_ID;
		const response = await fetch(`${ELEVENLABS_URL}/${voiceId}`, {
			method: 'POST',
			headers: { 'xi-api-key': apiKey, 'Content-Type': 'application/json', Accept: 'audio/mpeg' },
			body: JSON.stringify({ text, model_id: MODEL_ID, voice_settings: VOICE_SETTINGS }),
		});

		if (!response.ok) {
			return jsonResponse(response.status, { error: `Elevenlabs said no (status ${response.status}): ${await response.text()}` });
		}

		return new Response(Buffer.from(await response.arrayBuffer()), { status: 200, headers: { 'Content-Type': 'audio/mpeg' } });
	} catch (error) {
		console.error('tts failed:', error);
		return jsonResponse(500, { error: "Couldn't generate the audio :(" });
	}
}
