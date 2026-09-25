/**
 * The lambda entry point. Everything real (aurora, s3, elevenlabs) is wired up here and handed to the hono app in app.ts,
 * which is what the tests exercise with fakes instead
 */

import { PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { handle } from 'hono/aws-lambda';
import { createApp } from './app';
import { cardRepository } from './cards';
import { createDb, dbConfigFromEnv } from './db';
import { createSynthesiser } from './elevenlabs';

function required(name: string): string {
	const value = process.env[name];
	if (!value) {
		throw new Error(`${name} isn't set on the lambda :(`);
	}
	return value;
}

const s3 = new S3Client({});
const bucket = required('AUDIO_BUCKET');

const app = createApp({
	cards: cardRepository(createDb(dbConfigFromEnv())),
	adminPassword: required('ADMIN_PASSWORD'),
	allowedOrigins: required('ALLOWED_ORIGINS').split(','),
	audioBaseUrl: required('AUDIO_BASE_URL'),
	createUploadUrl: (key, contentType, ttlSeconds) =>
		getSignedUrl(s3, new PutObjectCommand({ Bucket: bucket, Key: key, ContentType: contentType }), { expiresIn: ttlSeconds }),
	synthesise: createSynthesiser({ apiKey: required('ELEVENLABS_API_KEY'), arabicVoiceId: required('ELEVENLABS_ARABIC_VOICE_ID') }),
});

export const handler = handle(app);
