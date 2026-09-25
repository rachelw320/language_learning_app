/**
 * Pushes every card in src/data/cards.json into the database. Existing cards get updated, so it's safe to run again.
 * Usage: npm run db:seed (after npm run db:migrate)
 */

import { readFileSync } from 'node:fs';
import { cardRepository } from '../api/src/cards';
import { createDb } from '../api/src/db';
import type { Card } from '../shared/card';
import { dbConfig } from './aws-config';

const cards = JSON.parse(readFileSync('src/data/cards.json', 'utf8')) as Card[];
await cardRepository(createDb(dbConfig())).upsertMany(cards);
console.log(`Seeded ${cards.length} cards`);
