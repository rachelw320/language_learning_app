import { defineConfig } from 'drizzle-kit';

// Only used to generate migration files from the schema (npm run db:generate). Applying them is scripts/db-migrate.ts
export default defineConfig({
	dialect: 'postgresql',
	schema: './api/src/schema.ts',
	out: './db/migrations',
});
