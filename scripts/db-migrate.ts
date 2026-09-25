/**
 * Applies any migrations in db/migrations that the database hasn't seen yet, over the rds data api.
 * Usage: npm run db:migrate (after npm run infra:deploy, with aws credentials on this machine)
 */

import { migrate } from 'drizzle-orm/aws-data-api/pg/migrator';
import { createDb } from '../api/src/db';
import { dbConfig } from './aws-config';

const db = createDb(dbConfig());
await migrate(db, { migrationsFolder: 'db/migrations' });
console.log('Database is up to date');
