import { Hono, type MiddlewareHandler } from 'hono';
import { cors } from 'hono/cors';
import { validator } from 'hono/validator';
import { randomUUID, timingSafeEqual } from 'node:crypto';
import type { z } from 'zod';
import { audioContentTypeSchema, newCardSchema, ttsSchema, uploadUrlSchema } from '../../shared/validation';
import type { CardRepository } from './cards';
import type { Synthesiser } from './elevenlabs';

// How long a presigned upload url stays valid. Long enough to upload a short clip, short enough not to leak much if it does
const UPLOAD_URL_TTL_SECONDS = 300;

const EXTENSIONS: Record<z.infer<typeof audioContentTypeSchema>, string> = {
	'audio/mp4': 'mp4',
	'audio/webm': 'webm',
	'audio/mpeg': 'mp3',
};

export interface AppDeps {
	cards: CardRepository;
	// The write routes need this in an x-admin-key header. It's a shared password, not accounts - fine for one person's app
	adminPassword: string;
	allowedOrigins: string[];
	// Where uploaded audio ends up being served from (the cloudfront domain)
	audioBaseUrl: string;
	createUploadUrl: (key: string, contentType: string, ttlSeconds: number) => Promise<string>;
	synthesise: Synthesiser;
}

function safeEqual(a: string, b: string): boolean {
	const left = Buffer.from(a);
	const right = Buffer.from(b);
	return left.length === right.length && timingSafeEqual(left, right);
}

function adminOnly(password: string): MiddlewareHandler {
	return async (c, next) => {
		const given = c.req.header('x-admin-key') ?? '';
		if (!password || !safeEqual(given, password)) {
			return c.json({ error: 'Admin password missing or wrong :(' }, 401);
		}
		await next();
	};
}

/** Validates the json body with a zod schema and turns the failures into a 400 that says what was wrong */
function json<T extends z.ZodTypeAny>(schema: T) {
	return validator('json', (value, c) => {
		const result = schema.safeParse(value);
		if (!result.success) {
			const problems = result.error.issues.map((issue) => `${issue.path.join('.') || 'body'}: ${issue.message}`);
			return c.json({ error: "That doesn't look right :(", problems }, 400);
		}
		return result.data as z.output<T>;
	});
}

export function createApp(deps: AppDeps) {
	const app = new Hono();
	const admin = adminOnly(deps.adminPassword);

	app.use('*', cors({ origin: deps.allowedOrigins, allowHeaders: ['Content-Type', 'x-admin-key'] }));

	app.get('/cards', async (c) => c.json(await deps.cards.list()));

	app.post('/cards', admin, json(newCardSchema), async (c) => c.json(await deps.cards.create(c.req.valid('json')), 201));

	// The browser uploads straight to s3 with a presigned url rather than pushing the bytes through the lambda
	app.post('/audio/upload-url', admin, json(uploadUrlSchema), async (c) => {
		const { language, contentType } = c.req.valid('json');
		const key = `audio/${language}/${Date.now()}-${randomUUID().slice(0, 8)}.${EXTENSIONS[contentType]}`;
		return c.json({
			uploadUrl: await deps.createUploadUrl(key, contentType, UPLOAD_URL_TTL_SECONDS),
			publicUrl: `${deps.audioBaseUrl}/${key}`,
		});
	});

	app.post('/tts', admin, json(ttsSchema), async (c) => {
		const { text, language } = c.req.valid('json');
		return c.body(await deps.synthesise(text, language), 200, { 'Content-Type': 'audio/mpeg' });
	});

	app.notFound((c) => c.json({ error: 'Nothing here :(' }, 404));

	app.onError((error, c) => {
		console.error(error);
		return c.json({ error: 'Something went wrong, not sure what :(' }, 500);
	});

	return app;
}

export type App = ReturnType<typeof createApp>;
