/**
 * Generates supabase-seed.sql from src/data/cards.json.
 * Paste the output into the Supabase SQL Editor and run it.
 *
 * Usage: node scripts/seed-supabase.mjs
 */

import { readFileSync, writeFileSync } from 'fs'
import { fileURLToPath } from 'url'
import { dirname, join } from 'path'

const __dirname = dirname(fileURLToPath(import.meta.url))
const cards = JSON.parse(readFileSync(join(__dirname, '../src/data/cards.json'), 'utf8'))

function s(val) {
  if (val === null || val === undefined) return 'NULL'
  return `'${String(val).replace(/'/g, "''")}'`
}

function arr(vals) {
  if (!vals || vals.length === 0) return "ARRAY[]::text[]"
  return `ARRAY[${vals.map(v => s(v)).join(', ')}]`
}

function jsonb(obj) {
  return `'${JSON.stringify(obj).replace(/'/g, "''")}'::jsonb`
}

const schema = `-- ════════════════════════════════════════════════════════
-- Egyptian Arabic App — Supabase schema + seed
-- Run this in: Supabase Dashboard → SQL Editor
-- Project: xavwkazvmpewmrnrxmsc
-- ════════════════════════════════════════════════════════

-- 1. Create table
CREATE TABLE IF NOT EXISTS cards (
  id                    TEXT PRIMARY KEY,
  category              TEXT NOT NULL,
  additional_categories TEXT[],
  "order"               INTEGER NOT NULL,
  deck                  TEXT,
  english               TEXT NOT NULL,
  arabic                TEXT NOT NULL,
  transliteration       TEXT NOT NULL,
  accepted              TEXT[] NOT NULL DEFAULT '{}',
  arabic_variants       TEXT[] NOT NULL DEFAULT '{}',
  audio                 JSONB NOT NULL DEFAULT '{"ar":"","en":""}',
  tags                  TEXT[] NOT NULL DEFAULT '{}',
  notes                 TEXT NOT NULL DEFAULT ''
);

-- 2. Indexes for fast category/tag queries
CREATE INDEX IF NOT EXISTS idx_cards_category
  ON cards(category);
CREATE INDEX IF NOT EXISTS idx_cards_order
  ON cards("order");
CREATE INDEX IF NOT EXISTS idx_cards_tags
  ON cards USING GIN(tags);
CREATE INDEX IF NOT EXISTS idx_cards_additional_categories
  ON cards USING GIN(additional_categories)
  WHERE additional_categories IS NOT NULL;

-- 3. Row-level security (cards are public read)
ALTER TABLE cards ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Cards are publicly readable" ON cards;
CREATE POLICY "Cards are publicly readable" ON cards
  FOR SELECT USING (true);

-- 4. Seed data (upsert — safe to re-run)
`

const rows = cards.map(c => `INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  (${s(c.id)}, ${s(c.category)}, ${c.additionalCategories ? arr(c.additionalCategories) : 'NULL'},
   ${c.order}, ${c.deck ? s(c.deck) : 'NULL'},
   ${s(c.english)}, ${s(c.arabic)}, ${s(c.transliteration)},
   ${arr(c.accepted)}, ${arr(c.arabicVariants)},
   ${jsonb(c.audio)}, ${arr(c.tags)}, ${s(c.notes)})
ON CONFLICT (id) DO UPDATE SET
  category              = EXCLUDED.category,
  additional_categories = EXCLUDED.additional_categories,
  "order"               = EXCLUDED."order",
  deck                  = EXCLUDED.deck,
  english               = EXCLUDED.english,
  arabic                = EXCLUDED.arabic,
  transliteration       = EXCLUDED.transliteration,
  accepted              = EXCLUDED.accepted,
  arabic_variants       = EXCLUDED.arabic_variants,
  audio                 = EXCLUDED.audio,
  tags                  = EXCLUDED.tags,
  notes                 = EXCLUDED.notes;`).join('\n\n')

const footer = `\n\n-- Verify\nSELECT COUNT(*) AS total_cards FROM cards;\n`

const sql = schema + rows + footer
const outPath = join(__dirname, '../supabase-seed.sql')
writeFileSync(outPath, sql)
console.log(`✓ Generated supabase-seed.sql (${cards.length} cards)`)
console.log(`  → Paste into Supabase SQL Editor and run`)
