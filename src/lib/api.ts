import type { AudioLanguage, NewCard } from '../../shared/validation';
import type { Card } from '../types';

// Set in .env locally and in the netlify dashboard. Without it the app just uses the bundled cards
const API_URL = (import.meta.env.VITE_API_URL as string | undefined)?.replace(/\/$/, '');

export const hasApi = Boolean(API_URL);

/** Calls the api and throws with the api's own message if it says no */
async function call(path: string, init: RequestInit = {}, adminKey?: string): Promise<Response> {
	if (!API_URL) {
		throw new Error('VITE_API_URL is not set :(');
	}
	const headers = new Headers(init.headers);
	if (adminKey) {
		headers.set('x-admin-key', adminKey);
	}
	if (init.body && !headers.has('Content-Type')) {
		headers.set('Content-Type', 'application/json');
	}
	const response = await fetch(`${API_URL}${path}`, { ...init, headers });
	if (!response.ok) {
		const body = (await response.json().catch(() => ({}))) as { error?: string };
		throw new Error(body.error ?? `The api returned ${response.status} :(`);
	}
	return response;
}

export async function fetchCards(): Promise<Card[]> {
	return (await call('/cards')).json();
}

export async function createCard(card: NewCard, adminKey: string): Promise<Card> {
	return (await call('/cards', { method: 'POST', body: JSON.stringify(card) }, adminKey)).json();
}

/** Uploads a recording straight to s3 with a presigned url from the api, and returns the url it'll be served from */
export async function uploadAudio(blob: Blob, language: AudioLanguage, adminKey: string): Promise<string> {
	const body = JSON.stringify({ language, contentType: blob.type });
	const { uploadUrl, publicUrl } = (await (await call('/audio/upload-url', { method: 'POST', body }, adminKey)).json()) as {
		uploadUrl: string;
		publicUrl: string;
	};
	const upload = await fetch(uploadUrl, { method: 'PUT', body: blob, headers: { 'Content-Type': blob.type } });
	if (!upload.ok) {
		throw new Error(`Couldn't upload the audio (status ${upload.status}) :(`);
	}
	return publicUrl;
}

export async function generateSpeech(text: string, language: AudioLanguage, adminKey: string): Promise<Blob> {
	return (await call('/tts', { method: 'POST', body: JSON.stringify({ text, language }) }, adminKey)).blob();
}
