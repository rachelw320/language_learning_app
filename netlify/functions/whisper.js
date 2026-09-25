/**
 * Netlify function that sends a recording to openai whisper and returns the transcription.
 * The app doesn't call this yet - it's here for the speaking practice mode that isn't built. POST a form with a "file" field
 */

import OpenAI, { toFile } from 'openai';

export const config = { path: '/.netlify/functions/whisper' };

function jsonResponse(status, body) {
	return new Response(JSON.stringify(body), { status, headers: { 'Content-Type': 'application/json' } });
}

export default async function handler(request) {
	if (request.method !== 'POST') {
		return jsonResponse(405, { error: 'Only POST works here' });
	}

	try {
		const formData = await request.formData();
		const recording = formData.get('file');
		if (!recording) {
			return jsonResponse(400, { error: "No file sent, can't transcribe nothing :(" });
		}

		const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
		// Telling whisper it's arabic helps a lot with the egyptian dialect
		const transcription = await openai.audio.transcriptions.create({
			file: await toFile(Buffer.from(await recording.arrayBuffer()), 'recording.mp4', { type: 'audio/mp4' }),
			model: 'whisper-1',
			language: 'ar',
		});

		return jsonResponse(200, { text: transcription.text });
	} catch (error) {
		console.error('whisper failed:', error);
		return jsonResponse(500, { error: "Couldn't transcribe the recording :(" });
	}
}
