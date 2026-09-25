/**
 * The cdk app. Reads the deployment settings from .env (or the environment) and defines one stack.
 * Usage: npm run infra:synth to check it, npm run infra:deploy to deploy it
 */

import * as cdk from 'aws-cdk-lib';
import { config } from 'dotenv';
import { EgyptianArabicStack } from '../lib/stack';

config();

// Missing values are allowed at synth time (github actions synths without secrets) but not at deploy time
function setting(name: string, fallback = ''): string {
	const value = process.env[name];
	if (!value) {
		console.warn(`${name} isn't set - fine for a synth, not for a deploy`);
		return fallback;
	}
	return value;
}

const app = new cdk.App();

new EgyptianArabicStack(app, 'EgyptianArabic', {
	env: { account: process.env.CDK_DEFAULT_ACCOUNT, region: process.env.CDK_DEFAULT_REGION },
	allowedOrigins: [...new Set([setting('APP_ORIGIN', 'http://localhost:3000'), 'http://localhost:3000'])],
	adminPassword: setting('ADMIN_PASSWORD'),
	elevenLabsApiKey: setting('ELEVENLABS_API_KEY'),
	elevenLabsArabicVoiceId: setting('ELEVENLABS_ARABIC_VOICE_ID'),
});
