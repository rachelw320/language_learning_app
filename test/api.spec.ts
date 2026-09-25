import { describe, expect, it } from 'vitest';
import { createApp } from '../api/src/app';
import type { CardRepository, NewCardInput } from '../api/src/cards';
import type { Card } from '../shared/card';

const sample: Card = {
	id: 'card_001',
	category: 'Top 50 Essentials',
	order: 1,
	english: 'What do you mean?',
	arabic: 'يعني إيه؟',
	transliteration: 'ya3ni eh',
	accepted: ['ya3ni eh'],
	arabicVariants: ['يعني إيه؟'],
	audio: { ar: '/audio/ar/card_001.mp3', en: '/audio/en/card_001.mp3' },
	tags: ['essentials', 'questions'],
	notes: '',
};

// Stands in for the database
function fakeRepository() {
	const created: NewCardInput[] = [];
	const repository: CardRepository = {
		async list() {
			return [sample];
		},
		async create(input) {
			created.push(input);
			return { ...sample, ...input, id: 'card_new', order: 2 };
		},
		async upsertMany() {},
	};
	return { repository, created };
}

const ADMIN = { 'x-admin-key': 'secret' };
const JSON_HEADERS = { 'Content-Type': 'application/json' };

function testApp(repository: CardRepository) {
	return createApp({
		cards: repository,
		adminPassword: 'secret',
		allowedOrigins: ['http://localhost:3000'],
		audioBaseUrl: 'https://cdn.example.com',
		createUploadUrl: async (key) => `https://bucket.example.com/${key}?signed`,
		synthesise: async () => new ArrayBuffer(3),
	});
}

describe('GET /cards', () => {
	it('returns every card without needing a password', async () => {
		const response = await testApp(fakeRepository().repository).request('/cards');
		expect(response.status).toBe(200);
		expect(await response.json()).toEqual([sample]);
	});
});

describe('admin routes', () => {
	it('say no without the password', async () => {
		const app = testApp(fakeRepository().repository);
		const missing = await app.request('/cards', { method: 'POST', headers: JSON_HEADERS, body: '{}' });
		expect(missing.status).toBe(401);
		const wrong = await app.request('/cards', { method: 'POST', headers: { ...JSON_HEADERS, 'x-admin-key': 'nope' }, body: '{}' });
		expect(wrong.status).toBe(401);
	});

	it('explain what was missing from a bad card', async () => {
		const app = testApp(fakeRepository().repository);
		const response = await app.request('/cards', {
			method: 'POST',
			headers: { ...JSON_HEADERS, ...ADMIN },
			body: JSON.stringify({ category: 'Food & Drink', arabic: 'شاي' }),
		});
		expect(response.status).toBe(400);
		const body = (await response.json()) as { problems: string[] };
		expect(body.problems.join(' ')).toContain('english');
		expect(body.problems.join(' ')).toContain('transliteration');
	});

	it('create a card and fill in the defaults', async () => {
		const { repository, created } = fakeRepository();
		const response = await testApp(repository).request('/cards', {
			method: 'POST',
			headers: { ...JSON_HEADERS, ...ADMIN },
			body: JSON.stringify({ category: 'Food & Drink', english: 'Tea', arabic: 'شاي', transliteration: 'shay' }),
		});
		expect(response.status).toBe(201);
		expect(created).toHaveLength(1);
		expect(created[0]).toMatchObject({ english: 'Tea', accepted: [], tags: [], notes: '', audio: { ar: '', en: '' } });
	});

	it('hand out an upload url under the audio folder', async () => {
		const response = await testApp(fakeRepository().repository).request('/audio/upload-url', {
			method: 'POST',
			headers: { ...JSON_HEADERS, ...ADMIN },
			body: JSON.stringify({ language: 'ar', contentType: 'audio/mp4' }),
		});
		expect(response.status).toBe(200);
		const body = (await response.json()) as { uploadUrl: string; publicUrl: string };
		expect(body.publicUrl).toMatch(/^https:\/\/cdn\.example\.com\/audio\/ar\/.+\.mp4$/);
		expect(body.uploadUrl).toContain('?signed');
	});

	it('refuse an upload for a file type the app never makes', async () => {
		const response = await testApp(fakeRepository().repository).request('/audio/upload-url', {
			method: 'POST',
			headers: { ...JSON_HEADERS, ...ADMIN },
			body: JSON.stringify({ language: 'ar', contentType: 'application/x-sh' }),
		});
		expect(response.status).toBe(400);
	});

	it('return mp3 bytes from tts', async () => {
		const response = await testApp(fakeRepository().repository).request('/tts', {
			method: 'POST',
			headers: { ...JSON_HEADERS, ...ADMIN },
			body: JSON.stringify({ text: 'شاي', language: 'ar' }),
		});
		expect(response.status).toBe(200);
		expect(response.headers.get('content-type')).toBe('audio/mpeg');
		expect((await response.arrayBuffer()).byteLength).toBe(3);
	});
});

describe('tts without elevenlabs', () => {
	it('says so rather than falling over', async () => {
		const { repository } = fakeRepository();
		const app = createApp({
			cards: repository,
			adminPassword: 'secret',
			allowedOrigins: [],
			audioBaseUrl: '',
			createUploadUrl: async () => '',
		});
		const response = await app.request('/tts', {
			method: 'POST',
			headers: { ...JSON_HEADERS, ...ADMIN },
			body: JSON.stringify({ text: 'شاي', language: 'ar' }),
		});
		expect(response.status).toBe(503);
	});
});

describe('the rest', () => {
	it('answers cors preflight for the app origin', async () => {
		const response = await testApp(fakeRepository().repository).request('/cards', {
			method: 'OPTIONS',
			headers: { Origin: 'http://localhost:3000', 'Access-Control-Request-Method': 'POST' },
		});
		expect(response.headers.get('access-control-allow-origin')).toBe('http://localhost:3000');
	});

	it('404s as json', async () => {
		const response = await testApp(fakeRepository().repository).request('/nothing');
		expect(response.status).toBe(404);
		expect(await response.json()).toEqual({ error: 'Nothing here :(' });
	});
});
