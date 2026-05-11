-- ════════════════════════════════════════════════════════
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
INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_001', 'Top 50 Essentials', NULL,
   1, 'essentials',
   'What do you mean?', 'يعني إيه؟', 'ya3ni eh',
   ARRAY['ya3ni eh', 'ya3ni eih', 'ya3ne eh', 'يعني إيه'], ARRAY['يعني إيه؟', 'يعني ايه'],
   '{"ar":"/audio/ar/card_001.mp3","en":"/audio/en/card_001.mp3"}'::jsonb, ARRAY['essentials', 'questions'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_002', 'Top 50 Essentials', NULL,
   2, 'essentials',
   'How are you? (to a man)', 'عامل إيه؟', '3aamel eh',
   ARRAY['3aamel eh', '3amel eh', '3aaml eh', 'عامل إيه'], ARRAY['عامل إيه؟', 'عامل ايه'],
   '{"ar":"/audio/ar/card_002.mp3","en":"/audio/en/card_002.mp3"}'::jsonb, ARRAY['essentials', 'greetings'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_003', 'Top 50 Essentials', NULL,
   3, 'essentials',
   'How are you? (to a woman)', 'عاملة إيه؟', '3amla eh',
   ARRAY['3amla eh', '3amla eih', '3amlah eh', 'عاملة إيه'], ARRAY['عاملة إيه؟', 'عاملة ايه'],
   '{"ar":"/audio/ar/card_003.mp3","en":"/audio/en/card_003.mp3"}'::jsonb, ARRAY['essentials', 'greetings'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_004', 'Top 50 Essentials', NULL,
   4, 'essentials',
   'How are you? (to a man)', 'إزيك؟', 'ezzayak',
   ARRAY['ezzayak', 'izzayak', 'ezayak', 'إزيك'], ARRAY['إزيك؟', 'ازيك'],
   '{"ar":"/audio/ar/card_004.mp3","en":"/audio/en/card_004.mp3"}'::jsonb, ARRAY['essentials', 'greetings'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_005', 'Top 50 Essentials', NULL,
   5, 'essentials',
   'How are you? (to a woman)', 'إزيك؟', 'ezzayek',
   ARRAY['ezzayek', 'izzayek', 'ezayek', 'إزيك'], ARRAY['إزيك؟', 'ازيك'],
   '{"ar":"/audio/ar/card_005.mp3","en":"/audio/en/card_005.mp3"}'::jsonb, ARRAY['essentials', 'greetings'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_006', 'Top 50 Essentials', NULL,
   6, 'essentials',
   'Thank God', 'الحمد لله', 'elhamdellah',
   ARRAY['elhamdellah', 'el hamd ellah', 'alhamdellah', 'elhamdulillah', 'الحمد لله'], ARRAY['الحمد لله'],
   '{"ar":"/audio/ar/card_006.mp3","en":"/audio/en/card_006.mp3"}'::jsonb, ARRAY['essentials', 'responses'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_007', 'Top 50 Essentials', NULL,
   7, 'essentials',
   'Fine (said by a man)', 'كويس', 'koweyyes',
   ARRAY['koweyyes', 'kweyyes', 'kwayes', 'kwayyes', 'كويس'], ARRAY['كويس'],
   '{"ar":"/audio/ar/card_007.mp3","en":"/audio/en/card_007.mp3"}'::jsonb, ARRAY['essentials', 'responses'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_008', 'Top 50 Essentials', NULL,
   8, 'essentials',
   'Fine (said by a woman)', 'كويسة', 'koweyyesa',
   ARRAY['koweyyesa', 'kweyyesa', 'kwayessa', 'kwessa', 'كويسة'], ARRAY['كويسة'],
   '{"ar":"/audio/ar/card_008.mp3","en":"/audio/en/card_008.mp3"}'::jsonb, ARRAY['essentials', 'responses'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_009', 'Top 50 Essentials', NULL,
   9, 'essentials',
   'Okay', 'تمام', 'tamaam',
   ARRAY['tamaam', 'tamam', 'tammam', 'تمام'], ARRAY['تمام'],
   '{"ar":"/audio/ar/card_009.mp3","en":"/audio/en/card_009.mp3"}'::jsonb, ARRAY['essentials', 'responses'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_010', 'Top 50 Essentials', NULL,
   10, 'essentials',
   'Alright / okay', 'ماشي', 'maashi',
   ARRAY['maashi', 'mashi', 'maashy', 'ماشي'], ARRAY['ماشي'],
   '{"ar":"/audio/ar/card_010.mp3","en":"/audio/en/card_010.mp3"}'::jsonb, ARRAY['essentials', 'responses'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_011', 'Top 50 Essentials', NULL,
   11, 'essentials',
   'Sure / understood', 'حاضر', 'haader',
   ARRAY['haader', 'hader', 'hadir', 'حاضر'], ARRAY['حاضر'],
   '{"ar":"/audio/ar/card_011.mp3","en":"/audio/en/card_011.mp3"}'::jsonb, ARRAY['essentials', 'responses'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_012', 'Top 50 Essentials', NULL,
   12, 'essentials',
   'Of course', 'أكيد', 'akeed',
   ARRAY['akeed', 'akid', '2akeed', 'أكيد'], ARRAY['أكيد', 'اكيد'],
   '{"ar":"/audio/ar/card_012.mp3","en":"/audio/en/card_012.mp3"}'::jsonb, ARRAY['essentials', 'responses'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_013', 'Top 50 Essentials', NULL,
   13, 'essentials',
   'Obviously', 'طبعاً', 'tab3an',
   ARRAY['tab3an', 'taba3an', 'طبعاً', 'طبعا'], ARRAY['طبعاً', 'طبعا'],
   '{"ar":"/audio/ar/card_013.mp3","en":"/audio/en/card_013.mp3"}'::jsonb, ARRAY['essentials', 'responses'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_014', 'Top 50 Essentials', NULL,
   14, 'essentials',
   'Seriously', 'بجد', 'begad',
   ARRAY['begad', 'bigad', 'be gad', 'بجد'], ARRAY['بجد'],
   '{"ar":"/audio/ar/card_014.mp3","en":"/audio/en/card_014.mp3"}'::jsonb, ARRAY['essentials', 'responses'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_015', 'Top 50 Essentials', NULL,
   15, 'essentials',
   'Honestly', 'بصراحة', 'besaraha',
   ARRAY['besaraha', 'bsaraha', 'be saraha', 'بصراحة'], ARRAY['بصراحة'],
   '{"ar":"/audio/ar/card_015.mp3","en":"/audio/en/card_015.mp3"}'::jsonb, ARRAY['essentials', 'responses'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_016', 'Top 50 Essentials', NULL,
   16, 'essentials',
   'Maybe', 'يمكن', 'yomken',
   ARRAY['yomken', 'yumken', 'momken', 'yomkan', 'يمكن'], ARRAY['يمكن', 'ممكن'],
   '{"ar":"/audio/ar/card_016.mp3","en":"/audio/en/card_016.mp3"}'::jsonb, ARRAY['essentials', 'responses'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_017', 'Top 50 Essentials', NULL,
   17, 'essentials',
   'Never mind / it''s okay', 'معلش', 'ma3lesh',
   ARRAY['ma3lesh', 'ma3lish', 'ma3leish', 'معلش'], ARRAY['معلش'],
   '{"ar":"/audio/ar/card_017.mp3","en":"/audio/en/card_017.mp3"}'::jsonb, ARRAY['essentials', 'responses'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_018', 'Top 50 Essentials', NULL,
   18, 'essentials',
   'Sorry (said by a man)', 'آسف', 'aassef',
   ARRAY['aassef', 'aasif', 'assef', 'آسف', 'اسف'], ARRAY['آسف', 'اسف'],
   '{"ar":"/audio/ar/card_018.mp3","en":"/audio/en/card_018.mp3"}'::jsonb, ARRAY['essentials', 'responses'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_019', 'Top 50 Essentials', NULL,
   19, 'essentials',
   'Sorry (said by a woman)', 'آسفة', 'aasfa',
   ARRAY['aasfa', 'asfa', 'آسفة', 'اسفة'], ARRAY['آسفة', 'اسفة'],
   '{"ar":"/audio/ar/card_019.mp3","en":"/audio/en/card_019.mp3"}'::jsonb, ARRAY['essentials', 'responses'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_020', 'Top 50 Essentials', NULL,
   20, 'essentials',
   'Thank you', 'شكراً', 'shokran',
   ARRAY['shokran', 'shukran', 'shokraan', 'شكراً', 'شكرا'], ARRAY['شكراً', 'شكرا'],
   '{"ar":"/audio/ar/card_020.mp3","en":"/audio/en/card_020.mp3"}'::jsonb, ARRAY['essentials', 'responses'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_021', 'Top 50 Essentials', NULL,
   21, 'essentials',
   'You''re welcome', 'العفو', 'el3afw',
   ARRAY['el3afw', 'el3afo', 'el 3afw', 'al3afw', 'العفو'], ARRAY['العفو'],
   '{"ar":"/audio/ar/card_021.mp3","en":"/audio/en/card_021.mp3"}'::jsonb, ARRAY['essentials', 'responses'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_022', 'Top 50 Essentials', NULL,
   22, 'essentials',
   'Yes', 'أه', 'aah',
   ARRAY['aah', 'ah', 'aywa', 'أه', 'آه'], ARRAY['أه', 'آه', 'أيوه'],
   '{"ar":"/audio/ar/card_022.mp3","en":"/audio/en/card_022.mp3"}'::jsonb, ARRAY['essentials', 'basics'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_023', 'Top 50 Essentials', NULL,
   23, 'essentials',
   'No', 'لا', 'la2',
   ARRAY['la2', 'la', 'laa', 'لا'], ARRAY['لا'],
   '{"ar":"/audio/ar/card_023.mp3","en":"/audio/en/card_023.mp3"}'::jsonb, ARRAY['essentials', 'basics'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_024', 'Top 50 Essentials', NULL,
   24, 'essentials',
   'I don''t know (said by a woman)', 'مش عارفة', 'mesh 3aarfa',
   ARRAY['mesh 3aarfa', 'mish 3arfa', 'mesh 3arfa', 'مش عارفة'], ARRAY['مش عارفة'],
   '{"ar":"/audio/ar/card_024.mp3","en":"/audio/en/card_024.mp3"}'::jsonb, ARRAY['essentials', 'understanding'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_025', 'Top 50 Essentials', NULL,
   25, 'essentials',
   'I don''t know (said by a man)', 'مش عارف', 'mesh 3aaref',
   ARRAY['mesh 3aaref', 'mish 3aref', 'mesh 3aref', 'مش عارف'], ARRAY['مش عارف'],
   '{"ar":"/audio/ar/card_025.mp3","en":"/audio/en/card_025.mp3"}'::jsonb, ARRAY['essentials', 'understanding'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_026', 'Top 50 Essentials', NULL,
   26, 'essentials',
   'I understand (said by a woman)', 'فاهمة', 'fahma',
   ARRAY['fahma', 'fahema', 'fahmah', 'فاهمة'], ARRAY['فاهمة'],
   '{"ar":"/audio/ar/card_026.mp3","en":"/audio/en/card_026.mp3"}'::jsonb, ARRAY['essentials', 'understanding'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_027', 'Top 50 Essentials', NULL,
   27, 'essentials',
   'I understand (said by a man)', 'فاهم', 'fahem',
   ARRAY['fahem', 'fahim', 'fahm', 'فاهم'], ARRAY['فاهم'],
   '{"ar":"/audio/ar/card_027.mp3","en":"/audio/en/card_027.mp3"}'::jsonb, ARRAY['essentials', 'understanding'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_028', 'Top 50 Essentials', NULL,
   28, 'essentials',
   'I don''t understand (said by a woman)', 'مش فاهمة', 'mesh fahma',
   ARRAY['mesh fahma', 'mish fahma', 'mesh fahema', 'مش فاهمة'], ARRAY['مش فاهمة'],
   '{"ar":"/audio/ar/card_028.mp3","en":"/audio/en/card_028.mp3"}'::jsonb, ARRAY['essentials', 'understanding'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_029', 'Top 50 Essentials', NULL,
   29, 'essentials',
   'I don''t understand (said by a man)', 'مش فاهم', 'mesh fahem',
   ARRAY['mesh fahem', 'mish fahem', 'mesh fahim', 'مش فاهم'], ARRAY['مش فاهم'],
   '{"ar":"/audio/ar/card_029.mp3","en":"/audio/en/card_029.mp3"}'::jsonb, ARRAY['essentials', 'understanding'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_030', 'Top 50 Essentials', NULL,
   30, 'essentials',
   'Wait a bit', 'استنى شوية', 'estanna showayya',
   ARRAY['estanna showayya', 'istanna showayya', 'estanna shwayya', 'استنى شوية'], ARRAY['استنى شوية', 'استنا شوية'],
   '{"ar":"/audio/ar/card_030.mp3","en":"/audio/en/card_030.mp3"}'::jsonb, ARRAY['essentials', 'communication'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_031', 'Top 50 Essentials', NULL,
   31, 'essentials',
   'Slowly / calm down', 'براحة', 'beraha',
   ARRAY['beraha', 'be raha', 'bi raha', 'براحة'], ARRAY['براحة'],
   '{"ar":"/audio/ar/card_031.mp3","en":"/audio/en/card_031.mp3"}'::jsonb, ARRAY['essentials', 'communication'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_032', 'Top 50 Essentials', NULL,
   32, 'essentials',
   'Say it again', 'قولها تاني', '2oolha taani',
   ARRAY['2oolha taani', '2olha tani', 'oolha taani', 'قولها تاني'], ARRAY['قولها تاني'],
   '{"ar":"/audio/ar/card_032.mp3","en":"/audio/en/card_032.mp3"}'::jsonb, ARRAY['essentials', 'communication'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_033', 'Top 50 Essentials', NULL,
   33, 'essentials',
   'How?', 'إزاي؟', 'ezzay',
   ARRAY['ezzay', 'izzay', 'ezay', 'إزاي'], ARRAY['إزاي؟', 'ازاي'],
   '{"ar":"/audio/ar/card_033.mp3","en":"/audio/en/card_033.mp3"}'::jsonb, ARRAY['essentials', 'questions'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_034', 'Top 50 Essentials', NULL,
   34, 'essentials',
   'Why?', 'ليه؟', 'leih',
   ARRAY['leih', 'leh', 'leeh', 'ليه'], ARRAY['ليه؟', 'ليه'],
   '{"ar":"/audio/ar/card_034.mp3","en":"/audio/en/card_034.mp3"}'::jsonb, ARRAY['essentials', 'questions'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_035', 'Top 50 Essentials', NULL,
   35, 'essentials',
   'Where?', 'فين؟', 'fein',
   ARRAY['fein', 'fen', 'feen', 'فين'], ARRAY['فين؟', 'فين'],
   '{"ar":"/audio/ar/card_035.mp3","en":"/audio/en/card_035.mp3"}'::jsonb, ARRAY['essentials', 'questions'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_036', 'Top 50 Essentials', NULL,
   36, 'essentials',
   'When?', 'إمتى؟', 'emta',
   ARRAY['emta', 'imta', 'emmta', 'إمتى'], ARRAY['إمتى؟', 'امتى'],
   '{"ar":"/audio/ar/card_036.mp3","en":"/audio/en/card_036.mp3"}'::jsonb, ARRAY['essentials', 'questions'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_037', 'Top 50 Essentials', NULL,
   37, 'essentials',
   'Who?', 'مين؟', 'meen',
   ARRAY['meen', 'min', 'mein', 'مين'], ARRAY['مين؟', 'مين'],
   '{"ar":"/audio/ar/card_037.mp3","en":"/audio/en/card_037.mp3"}'::jsonb, ARRAY['essentials', 'questions'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_038', 'Top 50 Essentials', NULL,
   38, 'essentials',
   'What is this?', 'إيه ده؟', 'eh da',
   ARRAY['eh da', 'eih da', 'eh dah', 'إيه ده'], ARRAY['إيه ده؟', 'ايه ده'],
   '{"ar":"/audio/ar/card_038.mp3","en":"/audio/en/card_038.mp3"}'::jsonb, ARRAY['essentials', 'questions'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_039', 'Top 50 Essentials', NULL,
   39, 'essentials',
   'I''m tired (said by a woman)', 'أنا تعبانة', 'ana ta3baana',
   ARRAY['ana ta3baana', 'ana ta3bana', 'ana ta3bane', 'أنا تعبانة'], ARRAY['أنا تعبانة'],
   '{"ar":"/audio/ar/card_039.mp3","en":"/audio/en/card_039.mp3"}'::jsonb, ARRAY['essentials', 'feelings'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_040', 'Top 50 Essentials', NULL,
   40, 'essentials',
   'I''m tired (said by a man)', 'أنا تعبان', 'ana ta3baan',
   ARRAY['ana ta3baan', 'ana ta3ban', 'أنا تعبان'], ARRAY['أنا تعبان'],
   '{"ar":"/audio/ar/card_040.mp3","en":"/audio/en/card_040.mp3"}'::jsonb, ARRAY['essentials', 'feelings'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_041', 'Top 50 Essentials', NULL,
   41, 'essentials',
   'I''m hungry (said by a woman)', 'أنا جعانة', 'ana ga3aana',
   ARRAY['ana ga3aana', 'ana ga3ana', 'أنا جعانة'], ARRAY['أنا جعانة'],
   '{"ar":"/audio/ar/card_041.mp3","en":"/audio/en/card_041.mp3"}'::jsonb, ARRAY['essentials', 'feelings'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_042', 'Top 50 Essentials', NULL,
   42, 'essentials',
   'I''m hungry (said by a man)', 'أنا جعان', 'ana ga3aan',
   ARRAY['ana ga3aan', 'ana ga3an', 'أنا جعان'], ARRAY['أنا جعان'],
   '{"ar":"/audio/ar/card_042.mp3","en":"/audio/en/card_042.mp3"}'::jsonb, ARRAY['essentials', 'feelings'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_043', 'Top 50 Essentials', NULL,
   43, 'essentials',
   'I''m thirsty (said by a woman)', 'أنا عطشانة', 'ana 3atshaana',
   ARRAY['ana 3atshaana', 'ana 3atshana', 'أنا عطشانة'], ARRAY['أنا عطشانة'],
   '{"ar":"/audio/ar/card_043.mp3","en":"/audio/en/card_043.mp3"}'::jsonb, ARRAY['essentials', 'feelings'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_044', 'Top 50 Essentials', NULL,
   44, 'essentials',
   'I''m thirsty (said by a man)', 'أنا عطشان', 'ana 3atshaan',
   ARRAY['ana 3atshaan', 'ana 3atshan', 'أنا عطشان'], ARRAY['أنا عطشان'],
   '{"ar":"/audio/ar/card_044.mp3","en":"/audio/en/card_044.mp3"}'::jsonb, ARRAY['essentials', 'feelings'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_045', 'Top 50 Essentials', NULL,
   45, 'essentials',
   'I''m happy (said by a woman)', 'أنا مبسوطة', 'ana mabsoota',
   ARRAY['ana mabsoota', 'ana mabsouta', 'أنا مبسوطة'], ARRAY['أنا مبسوطة'],
   '{"ar":"/audio/ar/card_045.mp3","en":"/audio/en/card_045.mp3"}'::jsonb, ARRAY['essentials', 'emotions'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_046', 'Top 50 Essentials', NULL,
   46, 'essentials',
   'I''m happy (said by a man)', 'أنا مبسوط', 'ana mabsoot',
   ARRAY['ana mabsoot', 'ana mabsout', 'أنا مبسوط'], ARRAY['أنا مبسوط'],
   '{"ar":"/audio/ar/card_046.mp3","en":"/audio/en/card_046.mp3"}'::jsonb, ARRAY['essentials', 'emotions'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_047', 'Top 50 Essentials', NULL,
   47, 'essentials',
   'I''m upset (said by a woman)', 'أنا زعلانة', 'ana za3laana',
   ARRAY['ana za3laana', 'ana za3lana', 'أنا زعلانة'], ARRAY['أنا زعلانة'],
   '{"ar":"/audio/ar/card_047.mp3","en":"/audio/en/card_047.mp3"}'::jsonb, ARRAY['essentials', 'emotions'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_048', 'Top 50 Essentials', NULL,
   48, 'essentials',
   'I''m upset (said by a man)', 'أنا زعلان', 'ana za3laan',
   ARRAY['ana za3laan', 'ana za3lan', 'أنا زعلان'], ARRAY['أنا زعلان'],
   '{"ar":"/audio/ar/card_048.mp3","en":"/audio/en/card_048.mp3"}'::jsonb, ARRAY['essentials', 'emotions'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_049', 'Top 50 Essentials', NULL,
   49, 'essentials',
   'I missed you', 'وحشتني', 'wahashteni',
   ARRAY['wahashteni', 'wahashtini', 'وحشتني'], ARRAY['وحشتني'],
   '{"ar":"/audio/ar/card_049.mp3","en":"/audio/en/card_049.mp3"}'::jsonb, ARRAY['essentials', 'emotions'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_050', 'Top 50 Essentials', NULL,
   50, 'essentials',
   'I love you (to a man)', 'بحبك', 'bahebbak',
   ARRAY['bahebbak', 'bahibbak', 'بحبك'], ARRAY['بحبك'],
   '{"ar":"/audio/ar/card_050.mp3","en":"/audio/en/card_050.mp3"}'::jsonb, ARRAY['essentials', 'emotions'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_051', 'Top 50 Essentials', NULL,
   51, 'essentials',
   'I love you (to a woman)', 'بحبك', 'bahebbek',
   ARRAY['bahebbek', 'bahibbek', 'بحبك'], ARRAY['بحبك'],
   '{"ar":"/audio/ar/card_051.mp3","en":"/audio/en/card_051.mp3"}'::jsonb, ARRAY['essentials', 'emotions'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_001', 'Core Verbs', NULL,
   1, NULL,
   'I go (f)', 'بروح', 'barooh',
   ARRAY['barooh', 'baroo7', 'ba rooh', 'ana barooh'], ARRAY['بروح'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'go'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_002', 'Core Verbs', NULL,
   2, NULL,
   'I go (m)', 'بروح', 'barooh',
   ARRAY['barooh', 'baroo7', 'ba rooh', 'ana barooh'], ARRAY['بروح'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'go'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_003', 'Core Verbs', NULL,
   3, NULL,
   'You go (to a man)', 'بتروح', 'betrooh',
   ARRAY['betrooh', 'betroo7', 'bet rooh', 'enta betrooh'], ARRAY['بتروح'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'go'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_004', 'Core Verbs', NULL,
   4, NULL,
   'You go (to a woman)', 'بتروحي', 'betroo7i',
   ARRAY['betroo7i', 'betroohi', 'betrooh i', 'enti betroo7i'], ARRAY['بتروحي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'go'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_005', 'Core Verbs', NULL,
   5, NULL,
   'He goes', 'بيروح', 'beyerooh',
   ARRAY['beyerooh', 'beyeroo7', 'beye rooh', 'howa beyerooh'], ARRAY['بيروح'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'go'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_006', 'Core Verbs', NULL,
   6, NULL,
   'She goes', 'بتروح', 'betrooh',
   ARRAY['betrooh', 'betroo7', 'bet rooh', 'heya betrooh'], ARRAY['بتروح'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'go'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_007', 'Core Verbs', NULL,
   7, NULL,
   'We go', 'بنروح', 'benrooh',
   ARRAY['benrooh', 'benroo7', 'ben rooh', 'ehna benrooh'], ARRAY['بنروح'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'go'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_008', 'Core Verbs', NULL,
   8, NULL,
   'They go', 'بيروحوا', 'beyeroo7o',
   ARRAY['beyeroo7o', 'beyeroohoo', 'beyeroho', 'homma beyeroo7o'], ARRAY['بيروحوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'go'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_009', 'Core Verbs', NULL,
   9, NULL,
   'I come (f)', 'باجي', 'baagi',
   ARRAY['baagi', 'bagy', 'ba gi', 'ana baagi'], ARRAY['باجي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'come'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_010', 'Core Verbs', NULL,
   10, NULL,
   'I come (m)', 'باجي', 'baagi',
   ARRAY['baagi', 'bagy', 'ba gi', 'ana baagi'], ARRAY['باجي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'come'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_011', 'Core Verbs', NULL,
   11, NULL,
   'You come (to a man)', 'بتيجي', 'beteegi',
   ARRAY['beteegi', 'beteeji', 'bete gi', 'enta beteegi'], ARRAY['بتيجي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'come'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_012', 'Core Verbs', NULL,
   12, NULL,
   'You come (to a woman)', 'بتيجي', 'beteegi',
   ARRAY['beteegi', 'beteeji', 'bete gi', 'enti beteegi'], ARRAY['بتيجي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'come'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_013', 'Core Verbs', NULL,
   13, NULL,
   'He comes', 'بيجي', 'beyeegi',
   ARRAY['beyeegi', 'beyeeji', 'beye gi', 'howa beyeegi'], ARRAY['بيجي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'come'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_014', 'Core Verbs', NULL,
   14, NULL,
   'She comes', 'بتيجي', 'beteegi',
   ARRAY['beteegi', 'beteeji', 'heya beteegi'], ARRAY['بتيجي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'come'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_015', 'Core Verbs', NULL,
   15, NULL,
   'We come', 'بنيجي', 'beneegi',
   ARRAY['beneegi', 'beneeji', 'bene gi', 'ehna beneegi'], ARRAY['بنيجي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'come'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_016', 'Core Verbs', NULL,
   16, NULL,
   'They come', 'بييجوا', 'beyeego',
   ARRAY['beyeego', 'beyeejo', 'beye go', 'homma beyeego'], ARRAY['بييجوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'come'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_017', 'Core Verbs', NULL,
   17, NULL,
   'I eat (f)', 'باكل', 'baakol',
   ARRAY['baakol', 'baakol', 'ba akol', 'ana baakol'], ARRAY['باكل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'eat'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_018', 'Core Verbs', NULL,
   18, NULL,
   'I eat (m)', 'باكل', 'baakol',
   ARRAY['baakol', 'ba akol', 'ana baakol'], ARRAY['باكل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'eat'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_019', 'Core Verbs', NULL,
   19, NULL,
   'You eat (to a man)', 'بتاكل', 'betaakol',
   ARRAY['betaakol', 'beta akol', 'bet aakol', 'enta betaakol'], ARRAY['بتاكل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'eat'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_020', 'Core Verbs', NULL,
   20, NULL,
   'You eat (to a woman)', 'بتاكلي', 'betaakoli',
   ARRAY['betaakoli', 'betaakolee', 'beta akoli', 'enti betaakoli'], ARRAY['بتاكلي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'eat'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_021', 'Core Verbs', NULL,
   21, NULL,
   'He eats', 'بياكل', 'beyaakol',
   ARRAY['beyaakol', 'beya akol', 'beye akol', 'howa beyaakol'], ARRAY['بياكل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'eat'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_022', 'Core Verbs', NULL,
   22, NULL,
   'She eats', 'بتاكل', 'betaakol',
   ARRAY['betaakol', 'beta akol', 'heya betaakol'], ARRAY['بتاكل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'eat'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_023', 'Core Verbs', NULL,
   23, NULL,
   'We eat', 'بناكل', 'benaakol',
   ARRAY['benaakol', 'bena akol', 'ben aakol', 'ehna benaakol'], ARRAY['بناكل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'eat'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_024', 'Core Verbs', NULL,
   24, NULL,
   'They eat', 'بياكلوا', 'beyaaklo',
   ARRAY['beyaaklo', 'beyaakloo', 'beye aklo', 'homma beyaaklo'], ARRAY['بياكلوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'eat'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_025', 'Core Verbs', NULL,
   25, NULL,
   'I drink (f)', 'بشرب', 'bashrab',
   ARRAY['bashrab', 'bash rab', 'ba shrab', 'ana bashrab'], ARRAY['بشرب'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'drink'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_026', 'Core Verbs', NULL,
   26, NULL,
   'I drink (m)', 'بشرب', 'bashrab',
   ARRAY['bashrab', 'bash rab', 'ba shrab', 'ana bashrab'], ARRAY['بشرب'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'drink'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_027', 'Core Verbs', NULL,
   27, NULL,
   'You drink (to a man)', 'بتشرب', 'beteshrab',
   ARRAY['beteshrab', 'bete shrab', 'bet eshrab', 'enta beteshrab'], ARRAY['بتشرب'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'drink'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_028', 'Core Verbs', NULL,
   28, NULL,
   'You drink (to a woman)', 'بتشربي', 'beteshrabi',
   ARRAY['beteshrabi', 'beteshrabee', 'bete shrabi', 'enti beteshrabi'], ARRAY['بتشربي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'drink'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_029', 'Core Verbs', NULL,
   29, NULL,
   'He drinks', 'بيشرب', 'beyeshrab',
   ARRAY['beyeshrab', 'beye shrab', 'bye shrab', 'howa beyeshrab'], ARRAY['بيشرب'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'drink'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_030', 'Core Verbs', NULL,
   30, NULL,
   'She drinks', 'بتشرب', 'beteshrab',
   ARRAY['beteshrab', 'bete shrab', 'heya beteshrab'], ARRAY['بتشرب'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'drink'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_031', 'Core Verbs', NULL,
   31, NULL,
   'We drink', 'بنشرب', 'beneshrab',
   ARRAY['beneshrab', 'bene shrab', 'ben eshrab', 'ehna beneshrab'], ARRAY['بنشرب'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'drink'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_032', 'Core Verbs', NULL,
   32, NULL,
   'They drink', 'بيشربوا', 'beyeshrabo',
   ARRAY['beyeshrabo', 'beye shrabo', 'bye shrabo', 'homma beyeshrabo'], ARRAY['بيشربوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'drink'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_033', 'Core Verbs', NULL,
   33, NULL,
   'I sleep (f)', 'بنام', 'banaam',
   ARRAY['banaam', 'banam', 'ba naam', 'ana banaam'], ARRAY['بنام'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'sleep'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_034', 'Core Verbs', NULL,
   34, NULL,
   'I sleep (m)', 'بنام', 'banaam',
   ARRAY['banaam', 'banam', 'ba naam', 'ana banaam'], ARRAY['بنام'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'sleep'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_035', 'Core Verbs', NULL,
   35, NULL,
   'You sleep (to a man)', 'بتنام', 'betenaam',
   ARRAY['betenaam', 'bete naam', 'bet enaam', 'enta betenaam'], ARRAY['بتنام'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'sleep'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_036', 'Core Verbs', NULL,
   36, NULL,
   'You sleep (to a woman)', 'بتنامي', 'betenaami',
   ARRAY['betenaami', 'bete naami', 'betenaamy', 'enti betenaami'], ARRAY['بتنامي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'sleep'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_037', 'Core Verbs', NULL,
   37, NULL,
   'He sleeps', 'بينام', 'beyenaam',
   ARRAY['beyenaam', 'beye naam', 'bye naam', 'howa beyenaam'], ARRAY['بينام'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'sleep'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_038', 'Core Verbs', NULL,
   38, NULL,
   'She sleeps', 'بتنام', 'betenaam',
   ARRAY['betenaam', 'bete naam', 'heya betenaam'], ARRAY['بتنام'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'sleep'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_039', 'Core Verbs', NULL,
   39, NULL,
   'We sleep', 'بنام', 'benenaam',
   ARRAY['benenaam', 'bene naam', 'ben enaam', 'ehna benenaam'], ARRAY['بنام'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'sleep'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_040', 'Core Verbs', NULL,
   40, NULL,
   'They sleep', 'بيناموا', 'beyenaamo',
   ARRAY['beyenaamo', 'beye naamo', 'bye naamo', 'homma beyenaamo'], ARRAY['بيناموا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'sleep'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_041', 'Core Verbs', NULL,
   41, NULL,
   'I wake up (f)', 'بصحى', 'basa7a',
   ARRAY['basa7a', 'basa7', 'ba sa7a', 'ana basa7a'], ARRAY['بصحى'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'wake'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_042', 'Core Verbs', NULL,
   42, NULL,
   'I wake up (m)', 'بصحى', 'basa7a',
   ARRAY['basa7a', 'basa7', 'ba sa7a', 'ana basa7a'], ARRAY['بصحى'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'wake'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_043', 'Core Verbs', NULL,
   43, NULL,
   'You wake up (to a man)', 'بتصحى', 'betesa7a',
   ARRAY['betesa7a', 'bete sa7a', 'bet esa7a', 'enta betesa7a'], ARRAY['بتصحى'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'wake'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_044', 'Core Verbs', NULL,
   44, NULL,
   'You wake up (to a woman)', 'بتصحي', 'betesa7i',
   ARRAY['betesa7i', 'bete sa7i', 'betesa7y', 'enti betesa7i'], ARRAY['بتصحي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'wake'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_045', 'Core Verbs', NULL,
   45, NULL,
   'He wakes up', 'بيصحى', 'beyesa7a',
   ARRAY['beyesa7a', 'beye sa7a', 'bye sa7a', 'howa beyesa7a'], ARRAY['بيصحى'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'wake'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_046', 'Core Verbs', NULL,
   46, NULL,
   'She wakes up', 'بتصحى', 'betesa7a',
   ARRAY['betesa7a', 'bete sa7a', 'heya betesa7a'], ARRAY['بتصحى'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'wake'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_047', 'Core Verbs', NULL,
   47, NULL,
   'We wake up', 'بنصحى', 'benesa7a',
   ARRAY['benesa7a', 'bene sa7a', 'ben esa7a', 'ehna benesa7a'], ARRAY['بنصحى'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'wake'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_048', 'Core Verbs', NULL,
   48, NULL,
   'They wake up', 'بيصحوا', 'beyesa7o',
   ARRAY['beyesa7o', 'beye sa7o', 'bye sa7o', 'homma beyesa7o'], ARRAY['بيصحوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'wake'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_049', 'Core Verbs', NULL,
   49, NULL,
   'I work (f)', 'بشتغل', 'bashteghal',
   ARRAY['bashteghal', 'bash teghal', 'ba shteghal', 'ana bashteghal'], ARRAY['بشتغل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'work'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_050', 'Core Verbs', NULL,
   50, NULL,
   'I work (m)', 'بشتغل', 'bashteghal',
   ARRAY['bashteghal', 'bash teghal', 'ba shteghal', 'ana bashteghal'], ARRAY['بشتغل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'work'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_051', 'Core Verbs', NULL,
   51, NULL,
   'You work (to a man)', 'بتشتغل', 'beteshteghal',
   ARRAY['beteshteghal', 'bete shteghal', 'bet eshteghal', 'enta beteshteghal'], ARRAY['بتشتغل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'work'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_052', 'Core Verbs', NULL,
   52, NULL,
   'You work (to a woman)', 'بتشتغلي', 'beteshteghali',
   ARRAY['beteshteghali', 'bete shteghali', 'beteshteghalee', 'enti beteshteghali'], ARRAY['بتشتغلي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'work'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_053', 'Core Verbs', NULL,
   53, NULL,
   'He works', 'بيشتغل', 'beyeshteghal',
   ARRAY['beyeshteghal', 'beye shteghal', 'bye shteghal', 'howa beyeshteghal'], ARRAY['بيشتغل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'work'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_054', 'Core Verbs', NULL,
   54, NULL,
   'She works', 'بتشتغل', 'beteshteghal',
   ARRAY['beteshteghal', 'bete shteghal', 'heya beteshteghal'], ARRAY['بتشتغل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'work'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_055', 'Core Verbs', NULL,
   55, NULL,
   'We work', 'بنشتغل', 'beneshteghal',
   ARRAY['beneshteghal', 'bene shteghal', 'ben eshteghal', 'ehna beneshteghal'], ARRAY['بنشتغل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'work'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_056', 'Core Verbs', NULL,
   56, NULL,
   'They work', 'بيشتغلوا', 'beyeshteghalo',
   ARRAY['beyeshteghalo', 'beye shteghalo', 'bye shteghalo', 'homma beyeshteghalo'], ARRAY['بيشتغلوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'work'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_057', 'Core Verbs', NULL,
   57, NULL,
   'I study (f)', 'بذاكر', 'bazaaker',
   ARRAY['bazaaker', 'ba zaaker', 'bazaker', 'ana bazaaker'], ARRAY['بذاكر'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'study'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_058', 'Core Verbs', NULL,
   58, NULL,
   'I study (m)', 'بذاكر', 'bazaaker',
   ARRAY['bazaaker', 'ba zaaker', 'bazaker', 'ana bazaaker'], ARRAY['بذاكر'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'study'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_059', 'Core Verbs', NULL,
   59, NULL,
   'You study (to a man)', 'بتذاكر', 'betazaaker',
   ARRAY['betazaaker', 'beta zaaker', 'bet azaaker', 'enta betazaaker'], ARRAY['بتذاكر'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'study'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_060', 'Core Verbs', NULL,
   60, NULL,
   'You study (to a woman)', 'بتذاكري', 'betazaakeri',
   ARRAY['betazaakeri', 'beta zaakeri', 'betazaakeree', 'enti betazaakeri'], ARRAY['بتذاكري'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'study'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_061', 'Core Verbs', NULL,
   61, NULL,
   'He studies', 'بيذاكر', 'beyezaaker',
   ARRAY['beyezaaker', 'beye zaaker', 'bye zaaker', 'howa beyezaaker'], ARRAY['بيذاكر'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'study'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_062', 'Core Verbs', NULL,
   62, NULL,
   'She studies', 'بتذاكر', 'betazaaker',
   ARRAY['betazaaker', 'beta zaaker', 'heya betazaaker'], ARRAY['بتذاكر'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'study'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_063', 'Core Verbs', NULL,
   63, NULL,
   'We study', 'بنذاكر', 'benezaaker',
   ARRAY['benezaaker', 'bene zaaker', 'ben ezaaker', 'ehna benezaaker'], ARRAY['بنذاكر'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'study'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_064', 'Core Verbs', NULL,
   64, NULL,
   'They study', 'بيذاكروا', 'beyezaakero',
   ARRAY['beyezaakero', 'beye zaakero', 'bye zaakero', 'homma beyezaakero'], ARRAY['بيذاكروا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'study'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_065', 'Core Verbs', NULL,
   65, NULL,
   'I think (f)', 'بفكر', 'bafakker',
   ARRAY['bafakker', 'ba fakker', 'bafaker', 'ana bafakker'], ARRAY['بفكر'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'think'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_066', 'Core Verbs', NULL,
   66, NULL,
   'I think (m)', 'بفكر', 'bafakker',
   ARRAY['bafakker', 'ba fakker', 'bafaker', 'ana bafakker'], ARRAY['بفكر'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'think'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_067', 'Core Verbs', NULL,
   67, NULL,
   'You think (to a man)', 'بتفكر', 'betefakker',
   ARRAY['betefakker', 'bete fakker', 'bet efakker', 'enta betefakker'], ARRAY['بتفكر'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'think'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_068', 'Core Verbs', NULL,
   68, NULL,
   'You think (to a woman)', 'بتفكري', 'betefakkeri',
   ARRAY['betefakkeri', 'bete fakkeri', 'betefakkeree', 'enti betefakkeri'], ARRAY['بتفكري'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'think'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_069', 'Core Verbs', NULL,
   69, NULL,
   'He thinks', 'بيفكر', 'beyefakker',
   ARRAY['beyefakker', 'beye fakker', 'bye fakker', 'howa beyefakker'], ARRAY['بيفكر'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'think'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_070', 'Core Verbs', NULL,
   70, NULL,
   'She thinks', 'بتفكر', 'betefakker',
   ARRAY['betefakker', 'bete fakker', 'heya betefakker'], ARRAY['بتفكر'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'think'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_071', 'Core Verbs', NULL,
   71, NULL,
   'We think', 'بنفكر', 'benefakker',
   ARRAY['benefakker', 'bene fakker', 'ben efakker', 'ehna benefakker'], ARRAY['بنفكر'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'think'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_072', 'Core Verbs', NULL,
   72, NULL,
   'They think', 'بيفكروا', 'beyefakkero',
   ARRAY['beyefakkero', 'beye fakkero', 'bye fakkero', 'homma beyefakkero'], ARRAY['بيفكروا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'think'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_073', 'Core Verbs', NULL,
   73, NULL,
   'I love (f)', 'بحب', 'ba7ebb',
   ARRAY['ba7ebb', 'ba7eb', 'ba hebb', 'ana ba7ebb'], ARRAY['بحب'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'love'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_074', 'Core Verbs', NULL,
   74, NULL,
   'I love (m)', 'بحب', 'ba7ebb',
   ARRAY['ba7ebb', 'ba7eb', 'ba hebb', 'ana ba7ebb'], ARRAY['بحب'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'love'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_075', 'Core Verbs', NULL,
   75, NULL,
   'You love (to a man)', 'بتحب', 'bete7ebb',
   ARRAY['bete7ebb', 'bete7eb', 'bete hebb', 'enta bete7ebb'], ARRAY['بتحب'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'love'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_076', 'Core Verbs', NULL,
   76, NULL,
   'You love (to a woman)', 'بتحبي', 'bete7ebbi',
   ARRAY['bete7ebbi', 'bete7ebbee', 'bete hebbi', 'enti bete7ebbi'], ARRAY['بتحبي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'love'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_077', 'Core Verbs', NULL,
   77, NULL,
   'He loves', 'بيحب', 'beye7ebb',
   ARRAY['beye7ebb', 'beye7eb', 'beye hebb', 'howa beye7ebb'], ARRAY['بيحب'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'love'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_078', 'Core Verbs', NULL,
   78, NULL,
   'She loves', 'بتحب', 'bete7ebb',
   ARRAY['bete7ebb', 'bete7eb', 'heya bete7ebb'], ARRAY['بتحب'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'love'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_079', 'Core Verbs', NULL,
   79, NULL,
   'We love', 'بنحب', 'bene7ebb',
   ARRAY['bene7ebb', 'bene7eb', 'bene hebb', 'ehna bene7ebb'], ARRAY['بنحب'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'love'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_080', 'Core Verbs', NULL,
   80, NULL,
   'They love', 'بيحبوا', 'beye7ebbo',
   ARRAY['beye7ebbo', 'beye7ebbo', 'beye hebbo', 'homma beye7ebbo'], ARRAY['بيحبوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'love'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_081', 'Core Verbs', NULL,
   81, NULL,
   'I disagree (f)', 'بختلف', 'bakhtalef',
   ARRAY['bakhtalef', 'bakhtalif', 'ba khtalef', 'ana bakhtalef'], ARRAY['بختلف'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'disagree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_082', 'Core Verbs', NULL,
   82, NULL,
   'I disagree (m)', 'بختلف', 'bakhtalef',
   ARRAY['bakhtalef', 'bakhtalif', 'ba khtalef', 'ana bakhtalef'], ARRAY['بختلف'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'disagree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_083', 'Core Verbs', NULL,
   83, NULL,
   'You disagree (to a man)', 'بتختلف', 'betekhtalef',
   ARRAY['betekhtalef', 'betekhtalif', 'bete khtalef', 'enta betekhtalef'], ARRAY['بتختلف'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'disagree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_084', 'Core Verbs', NULL,
   84, NULL,
   'You disagree (to a woman)', 'بتختلفي', 'betekhtalefi',
   ARRAY['betekhtalefi', 'betekhtalifi', 'bete khtalefi', 'enti betekhtalefi'], ARRAY['بتختلفي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'disagree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_085', 'Core Verbs', NULL,
   85, NULL,
   'He disagrees', 'بيختلف', 'beyekhtalef',
   ARRAY['beyekhtalef', 'beyekhtalif', 'beye khtalef', 'howa beyekhtalef'], ARRAY['بيختلف'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'disagree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_086', 'Core Verbs', NULL,
   86, NULL,
   'She disagrees', 'بتختلف', 'betekhtalef',
   ARRAY['betekhtalef', 'betekhtalif', 'heya betekhtalef'], ARRAY['بتختلف'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'disagree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_087', 'Core Verbs', NULL,
   87, NULL,
   'We disagree', 'بنختلف', 'benekhtalef',
   ARRAY['benekhtalef', 'benekhtalif', 'bene khtalef', 'ehna benekhtalef'], ARRAY['بنختلف'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'disagree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_088', 'Core Verbs', NULL,
   88, NULL,
   'They disagree', 'بيختلفوا', 'beyekhtalefo',
   ARRAY['beyekhtalefo', 'beyekhtalfo', 'beye khtalefo', 'homma beyekhtalefo'], ARRAY['بيختلفوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'disagree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_089', 'Core Verbs', NULL,
   89, NULL,
   'I agree (f)', 'بتفق', 'bettefe2',
   ARRAY['bettefe2', 'bettef2', 'bettefe', 'ana bettefe2'], ARRAY['بتفق'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'agree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_090', 'Core Verbs', NULL,
   90, NULL,
   'I agree (m)', 'بتفق', 'bettefe2',
   ARRAY['bettefe2', 'bettef2', 'bettefe', 'ana bettefe2'], ARRAY['بتفق'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'agree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_091', 'Core Verbs', NULL,
   91, NULL,
   'You agree (to a man)', 'بتتفق', 'betettefe2',
   ARRAY['betettefe2', 'betettef2', 'betettefe', 'enta betettefe2'], ARRAY['بتتفق'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'agree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_092', 'Core Verbs', NULL,
   92, NULL,
   'You agree (to a woman)', 'بتتفقي', 'betettefe2i',
   ARRAY['betettefe2i', 'betettef2i', 'betetefqi', 'enti betettefe2i'], ARRAY['بتتفقي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'agree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_093', 'Core Verbs', NULL,
   93, NULL,
   'He agrees', 'بيتفق', 'beyettefe2',
   ARRAY['beyettefe2', 'beyettef2', 'beyettefe', 'howa beyettefe2'], ARRAY['بيتفق'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'agree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_094', 'Core Verbs', NULL,
   94, NULL,
   'She agrees', 'بتتفق', 'betettefe2',
   ARRAY['betettefe2', 'betettef2', 'heya betettefe2'], ARRAY['بتتفق'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'agree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_095', 'Core Verbs', NULL,
   95, NULL,
   'We agree', 'بنتفق', 'benettefe2',
   ARRAY['benettefe2', 'benettef2', 'benettefe', 'ehna benettefe2'], ARRAY['بنتفق'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'agree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_096', 'Core Verbs', NULL,
   96, NULL,
   'They agree', 'بيتفقوا', 'beyettefe2o',
   ARRAY['beyettefe2o', 'beyettef2o', 'beyettefo', 'homma beyettefe2o'], ARRAY['بيتفقوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'agree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_097', 'Core Verbs', NULL,
   97, NULL,
   'I debate (f)', 'بناقش', 'benaa2esh',
   ARRAY['benaa2esh', 'benaaqesh', 'bena2esh', 'benaesh', 'ana benaa2esh'], ARRAY['بناقش'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'debate'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_098', 'Core Verbs', NULL,
   98, NULL,
   'I debate (m)', 'بناقش', 'benaa2esh',
   ARRAY['benaa2esh', 'benaaqesh', 'bena2esh', 'benaesh', 'ana benaa2esh'], ARRAY['بناقش'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'debate'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_099', 'Core Verbs', NULL,
   99, NULL,
   'You debate (to a man)', 'بتناقش', 'betenaa2esh',
   ARRAY['betenaa2esh', 'betenaaqesh', 'betena2esh', 'enta betenaa2esh'], ARRAY['بتناقش'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'debate'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_100', 'Core Verbs', NULL,
   100, NULL,
   'You debate (to a woman)', 'بتناقشي', 'betenaa2eshi',
   ARRAY['betenaa2eshi', 'betenaaqeshi', 'betena2eshi', 'enti betenaa2eshi'], ARRAY['بتناقشي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'debate'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_101', 'Core Verbs', NULL,
   101, NULL,
   'He debates', 'بيناقش', 'beyenaa2esh',
   ARRAY['beyenaa2esh', 'beyenaaqesh', 'beyena2esh', 'howa beyenaa2esh'], ARRAY['بيناقش'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'debate'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_102', 'Core Verbs', NULL,
   102, NULL,
   'She debates', 'بتناقش', 'betenaa2esh',
   ARRAY['betenaa2esh', 'betenaaqesh', 'heya betenaa2esh'], ARRAY['بتناقش'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'debate'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_103', 'Core Verbs', NULL,
   103, NULL,
   'We debate', 'بنناقش', 'benenaa2esh',
   ARRAY['benenaa2esh', 'benenaaqesh', 'benena2esh', 'ehna benenaa2esh'], ARRAY['بنناقش'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'debate'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_104', 'Core Verbs', NULL,
   104, NULL,
   'They debate', 'بيناقشوا', 'beyenaa2esho',
   ARRAY['beyenaa2esho', 'beyenaaqesho', 'beyena2esho', 'homma beyenaa2esho'], ARRAY['بيناقشوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'debate'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_105', 'Core Verbs', NULL,
   105, NULL,
   'I explain (f)', 'بشرح', 'bashra7',
   ARRAY['bashra7', 'bashrakh', 'bashrach', 'bashrah', 'ana bashra7'], ARRAY['بشرح'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'explain'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_106', 'Core Verbs', NULL,
   106, NULL,
   'I explain (m)', 'بشرح', 'bashra7',
   ARRAY['bashra7', 'bashrakh', 'bashrach', 'bashrah', 'ana bashra7'], ARRAY['بشرح'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'explain'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_107', 'Core Verbs', NULL,
   107, NULL,
   'You explain (to a man)', 'بتشرح', 'beteshra7',
   ARRAY['beteshra7', 'beteshrakh', 'beteshrach', 'enta beteshra7'], ARRAY['بتشرح'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'explain'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_108', 'Core Verbs', NULL,
   108, NULL,
   'You explain (to a woman)', 'بتشرحي', 'beteshra7i',
   ARRAY['beteshra7i', 'beteshrakhi', 'beteshrachi', 'enti beteshra7i'], ARRAY['بتشرحي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'explain'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_109', 'Core Verbs', NULL,
   109, NULL,
   'He explains', 'بيشرح', 'beyeshra7',
   ARRAY['beyeshra7', 'beyeshrakh', 'beyeshrach', 'howa beyeshra7'], ARRAY['بيشرح'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'explain'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_110', 'Core Verbs', NULL,
   110, NULL,
   'She explains', 'بتشرح', 'beteshra7',
   ARRAY['beteshra7', 'beteshrakh', 'heya beteshra7'], ARRAY['بتشرح'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'explain'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_111', 'Core Verbs', NULL,
   111, NULL,
   'We explain', 'بنشرح', 'beneshra7',
   ARRAY['beneshra7', 'beneshrakh', 'beneshrach', 'ehna beneshra7'], ARRAY['بنشرح'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'explain'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_112', 'Core Verbs', NULL,
   112, NULL,
   'They explain', 'بيشرحوا', 'beyeshra7o',
   ARRAY['beyeshra7o', 'beyeshrakho', 'beyeshracho', 'homma beyeshra7o'], ARRAY['بيشرحوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'explain'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_113', 'Core Verbs', NULL,
   113, NULL,
   'I analyse (f)', 'بحلل', 'ba7allel',
   ARRAY['ba7allel', 'baallel', 'ba hallel', 'ba7alel', 'ana ba7allel'], ARRAY['بحلل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'analyse'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_114', 'Core Verbs', NULL,
   114, NULL,
   'I analyse (m)', 'بحلل', 'ba7allel',
   ARRAY['ba7allel', 'baallel', 'ba hallel', 'ba7alel', 'ana ba7allel'], ARRAY['بحلل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'analyse'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_115', 'Core Verbs', NULL,
   115, NULL,
   'You analyse (to a man)', 'بتحلل', 'bete7allel',
   ARRAY['bete7allel', 'beteallel', 'bete hallel', 'enta bete7allel'], ARRAY['بتحلل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'analyse'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_116', 'Core Verbs', NULL,
   116, NULL,
   'You analyse (to a woman)', 'بتحللي', 'bete7alleli',
   ARRAY['bete7alleli', 'betealleli', 'bete halleli', 'enti bete7alleli'], ARRAY['بتحللي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'analyse'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_117', 'Core Verbs', NULL,
   117, NULL,
   'He analyses', 'بيحلل', 'beye7allel',
   ARRAY['beye7allel', 'beyeallel', 'beye hallel', 'howa beye7allel'], ARRAY['بيحلل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'analyse'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_118', 'Core Verbs', NULL,
   118, NULL,
   'She analyses', 'بتحلل', 'bete7allel',
   ARRAY['bete7allel', 'beteallel', 'heya bete7allel'], ARRAY['بتحلل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'analyse'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_119', 'Core Verbs', NULL,
   119, NULL,
   'We analyse', 'بنحلل', 'bene7allel',
   ARRAY['bene7allel', 'beneallel', 'bene hallel', 'ehna bene7allel'], ARRAY['بنحلل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'analyse'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_120', 'Core Verbs', NULL,
   120, NULL,
   'They analyse', 'بيحللوا', 'beye7allelo',
   ARRAY['beye7allelo', 'beyeallelo', 'beye hallelo', 'homma beye7allelo'], ARRAY['بيحللوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'analyse'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_121', 'Core Verbs', NULL,
   121, NULL,
   'I criticise (f)', 'بنتقد', 'bent2ed',
   ARRAY['bent2ed', 'bentqed', 'bente2ed', 'benteed', 'ana bent2ed'], ARRAY['بنتقد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'criticise'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_122', 'Core Verbs', NULL,
   122, NULL,
   'I criticise (m)', 'بنتقد', 'bent2ed',
   ARRAY['bent2ed', 'bentqed', 'bente2ed', 'benteed', 'ana bent2ed'], ARRAY['بنتقد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'criticise'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_123', 'Core Verbs', NULL,
   123, NULL,
   'You criticise (to a man)', 'بتنتقد', 'betent2ed',
   ARRAY['betent2ed', 'betentqed', 'betente2ed', 'enta betent2ed'], ARRAY['بتنتقد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'criticise'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_124', 'Core Verbs', NULL,
   124, NULL,
   'You criticise (to a woman)', 'بتنتقدي', 'betent2edi',
   ARRAY['betent2edi', 'betentqedi', 'betente2edi', 'enti betent2edi'], ARRAY['بتنتقدي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'criticise'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_125', 'Core Verbs', NULL,
   125, NULL,
   'He criticises', 'بينتقد', 'beyent2ed',
   ARRAY['beyent2ed', 'beyentqed', 'beyente2ed', 'howa beyent2ed'], ARRAY['بينتقد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'criticise'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_126', 'Core Verbs', NULL,
   126, NULL,
   'She criticises', 'بتنتقد', 'betent2ed',
   ARRAY['betent2ed', 'betentqed', 'heya betent2ed'], ARRAY['بتنتقد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'criticise'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_127', 'Core Verbs', NULL,
   127, NULL,
   'We criticise', 'بننتقد', 'benent2ed',
   ARRAY['benent2ed', 'benentqed', 'benente2ed', 'ehna benent2ed'], ARRAY['بننتقد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'criticise'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_128', 'Core Verbs', NULL,
   128, NULL,
   'They criticise', 'بينتقدوا', 'beyent2edo',
   ARRAY['beyent2edo', 'beyentqedo', 'beyente2edo', 'homma beyent2edo'], ARRAY['بينتقدوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'criticise'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_129', 'Core Verbs', NULL,
   129, NULL,
   'I support (f)', 'بدعم', 'bada3am',
   ARRAY['bada3am', 'badaam', 'bada am', 'bada3em', 'ana bada3am'], ARRAY['بدعم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'support'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_130', 'Core Verbs', NULL,
   130, NULL,
   'I support (m)', 'بدعم', 'bada3am',
   ARRAY['bada3am', 'badaam', 'bada am', 'bada3em', 'ana bada3am'], ARRAY['بدعم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'support'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_131', 'Core Verbs', NULL,
   131, NULL,
   'You support (to a man)', 'بتدعم', 'bited3am',
   ARRAY['bited3am', 'bitedaam', 'bete d3am', 'beted3am', 'enta bited3am'], ARRAY['بتدعم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'support'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_132', 'Core Verbs', NULL,
   132, NULL,
   'You support (to a woman)', 'بتدعمي', 'bited3ami',
   ARRAY['bited3ami', 'bitedaami', 'beted3ami', 'enti bited3ami'], ARRAY['بتدعمي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'support'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_133', 'Core Verbs', NULL,
   133, NULL,
   'He supports', 'بيدعم', 'beyed3am',
   ARRAY['beyed3am', 'beyedaam', 'beye d3am', 'howa beyed3am'], ARRAY['بيدعم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'support'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_134', 'Core Verbs', NULL,
   134, NULL,
   'She supports', 'بتدعم', 'bited3am',
   ARRAY['bited3am', 'bitedaam', 'heya bited3am'], ARRAY['بتدعم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'support'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_135', 'Core Verbs', NULL,
   135, NULL,
   'We support', 'بندعم', 'bened3am',
   ARRAY['bened3am', 'benedaam', 'bene d3am', 'ehna bened3am'], ARRAY['بندعم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'support'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_136', 'Core Verbs', NULL,
   136, NULL,
   'They support', 'بيدعموا', 'beyed3amo',
   ARRAY['beyed3amo', 'beyedaamo', 'beye d3amo', 'homma beyed3amo'], ARRAY['بيدعموا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'support'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_137', 'Core Verbs', NULL,
   137, NULL,
   'I oppose (f)', 'بعارض', 'ba3aared',
   ARRAY['ba3aared', 'baaared', 'ba3ared', 'ba aaared', 'ana ba3aared'], ARRAY['بعارض'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'oppose'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_138', 'Core Verbs', NULL,
   138, NULL,
   'I oppose (m)', 'بعارض', 'ba3aared',
   ARRAY['ba3aared', 'baaared', 'ba3ared', 'ba aaared', 'ana ba3aared'], ARRAY['بعارض'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'oppose'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_139', 'Core Verbs', NULL,
   139, NULL,
   'You oppose (to a man)', 'بتعارض', 'beta3aared',
   ARRAY['beta3aared', 'betaaared', 'beta3ared', 'enta beta3aared'], ARRAY['بتعارض'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'oppose'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_140', 'Core Verbs', NULL,
   140, NULL,
   'You oppose (to a woman)', 'بتعارضي', 'beta3aaredi',
   ARRAY['beta3aaredi', 'betaaaredi', 'beta3aredi', 'enti beta3aaredi'], ARRAY['بتعارضي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'oppose'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_141', 'Core Verbs', NULL,
   141, NULL,
   'He opposes', 'بيعارض', 'beya3aared',
   ARRAY['beya3aared', 'beyaaared', 'beya3ared', 'howa beya3aared'], ARRAY['بيعارض'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'oppose'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_142', 'Core Verbs', NULL,
   142, NULL,
   'She opposes', 'بتعارض', 'beta3aared',
   ARRAY['beta3aared', 'betaaared', 'heya beta3aared'], ARRAY['بتعارض'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'oppose'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_143', 'Core Verbs', NULL,
   143, NULL,
   'We oppose', 'بنعارض', 'bena3aared',
   ARRAY['bena3aared', 'benaaared', 'bena3ared', 'ehna bena3aared'], ARRAY['بنعارض'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'oppose'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_144', 'Core Verbs', NULL,
   144, NULL,
   'They oppose', 'بيعارضوا', 'beya3aaredo',
   ARRAY['beya3aaredo', 'beyaaaredo', 'beya3aredo', 'homma beya3aaredo'], ARRAY['بيعارضوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'oppose'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_145', 'Core Verbs', NULL,
   145, NULL,
   'I believe (f)', 'بصدق', 'basadda2',
   ARRAY['basadda2', 'basaddaq', 'basaddak', 'ba sadda2', 'ana basadda2'], ARRAY['بصدق'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'believe'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_146', 'Core Verbs', NULL,
   146, NULL,
   'I believe (m)', 'بصدق', 'basadda2',
   ARRAY['basadda2', 'basaddaq', 'basaddak', 'ba sadda2', 'ana basadda2'], ARRAY['بصدق'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'believe'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_147', 'Core Verbs', NULL,
   147, NULL,
   'You believe (to a man)', 'بتصدق', 'betesadda2',
   ARRAY['betesadda2', 'betesaddaq', 'betesadda', 'enta betesadda2'], ARRAY['بتصدق'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'believe'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_148', 'Core Verbs', NULL,
   148, NULL,
   'You believe (to a woman)', 'بتصدقي', 'betesadda2i',
   ARRAY['betesadda2i', 'betesaddaqi', 'betesaddai', 'enti betesadda2i'], ARRAY['بتصدقي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'believe'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_149', 'Core Verbs', NULL,
   149, NULL,
   'He believes', 'بيصدق', 'beyesadda2',
   ARRAY['beyesadda2', 'beyesaddaq', 'beyesadda', 'howa beyesadda2'], ARRAY['بيصدق'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'believe'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_150', 'Core Verbs', NULL,
   150, NULL,
   'She believes', 'بتصدق', 'betesadda2',
   ARRAY['betesadda2', 'betesaddaq', 'heya betesadda2'], ARRAY['بتصدق'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'believe'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_151', 'Core Verbs', NULL,
   151, NULL,
   'We believe', 'بنصدق', 'benesadda2',
   ARRAY['benesadda2', 'benesaddaq', 'benesadda', 'ehna benesadda2'], ARRAY['بنصدق'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'believe'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_152', 'Core Verbs', NULL,
   152, NULL,
   'They believe', 'بيصدقوا', 'beyesadda2o',
   ARRAY['beyesadda2o', 'beyesaddaqo', 'beyesaddao', 'homma beyesadda2o'], ARRAY['بيصدقوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'believe'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_153', 'Core Verbs', NULL,
   153, NULL,
   'I doubt (f)', 'بشك', 'bashokk',
   ARRAY['bashokk', 'bashok', 'ba shokk', 'bashok', 'ana bashokk'], ARRAY['بشك'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'doubt'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_154', 'Core Verbs', NULL,
   154, NULL,
   'I doubt (m)', 'بشك', 'bashokk',
   ARRAY['bashokk', 'bashok', 'ba shokk', 'ana bashokk'], ARRAY['بشك'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'doubt'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_155', 'Core Verbs', NULL,
   155, NULL,
   'You doubt (to a man)', 'بتشك', 'beteshokk',
   ARRAY['beteshokk', 'beteshok', 'bete shokk', 'enta beteshokk'], ARRAY['بتشك'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'doubt'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_156', 'Core Verbs', NULL,
   156, NULL,
   'You doubt (to a woman)', 'بتشكي', 'beteshokki',
   ARRAY['beteshokki', 'beteshoki', 'bete shokki', 'enti beteshokki'], ARRAY['بتشكي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'doubt'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_157', 'Core Verbs', NULL,
   157, NULL,
   'He doubts', 'بيشك', 'beyeshokk',
   ARRAY['beyeshokk', 'beyeshok', 'beye shokk', 'howa beyeshokk'], ARRAY['بيشك'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'doubt'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_158', 'Core Verbs', NULL,
   158, NULL,
   'She doubts', 'بتشك', 'beteshokk',
   ARRAY['beteshokk', 'beteshok', 'heya beteshokk'], ARRAY['بتشك'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'doubt'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_159', 'Core Verbs', NULL,
   159, NULL,
   'We doubt', 'بنشك', 'beneshokk',
   ARRAY['beneshokk', 'beneshok', 'bene shokk', 'ehna beneshokk'], ARRAY['بنشك'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'doubt'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_160', 'Core Verbs', NULL,
   160, NULL,
   'They doubt', 'بيشكوا', 'beyeshokko',
   ARRAY['beyeshokko', 'beyeshoko', 'beye shokko', 'homma beyeshokko'], ARRAY['بيشكوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'doubt'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_161', 'Core Verbs', NULL,
   161, NULL,
   'I influence (f)', 'بأثر', 'ba2assar',
   ARRAY['ba2assar', 'baassar', 'ba assar', 'ba2asser', 'ana ba2assar'], ARRAY['بأثر'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'influence'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_162', 'Core Verbs', NULL,
   162, NULL,
   'I influence (m)', 'بأثر', 'ba2assar',
   ARRAY['ba2assar', 'baassar', 'ba assar', 'ba2asser', 'ana ba2assar'], ARRAY['بأثر'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'influence'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_163', 'Core Verbs', NULL,
   163, NULL,
   'You influence (to a man)', 'بتأثر', 'bete2assar',
   ARRAY['bete2assar', 'beteassar', 'bete assar', 'enta bete2assar'], ARRAY['بتأثر'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'influence'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_164', 'Core Verbs', NULL,
   164, NULL,
   'You influence (to a woman)', 'بتأثري', 'bete2assari',
   ARRAY['bete2assari', 'beteassari', 'bete assari', 'enti bete2assari'], ARRAY['بتأثري'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'influence'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_165', 'Core Verbs', NULL,
   165, NULL,
   'He influences', 'بيأثر', 'beye2assar',
   ARRAY['beye2assar', 'beyeassar', 'beye assar', 'howa beye2assar'], ARRAY['بيأثر'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'influence'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_166', 'Core Verbs', NULL,
   166, NULL,
   'She influences', 'بتأثر', 'bete2assar',
   ARRAY['bete2assar', 'beteassar', 'heya bete2assar'], ARRAY['بتأثر'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'influence'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_167', 'Core Verbs', NULL,
   167, NULL,
   'We influence', 'بنأثر', 'bene2assar',
   ARRAY['bene2assar', 'beneassar', 'bene assar', 'ehna bene2assar'], ARRAY['بنأثر'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'influence'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_168', 'Core Verbs', NULL,
   168, NULL,
   'They influence', 'بيأثروا', 'beye2assaro',
   ARRAY['beye2assaro', 'beyeassaro', 'beye assaro', 'homma beye2assaro'], ARRAY['بيأثروا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'influence'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_169', 'Core Verbs', NULL,
   169, NULL,
   'I respect (f)', 'بحترم', 'ba7tarem',
   ARRAY['ba7tarem', 'bahtarem', 'ba7terem', 'ba htarem', 'ana ba7tarem'], ARRAY['بحترم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'respect'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_170', 'Core Verbs', NULL,
   170, NULL,
   'I respect (m)', 'بحترم', 'ba7tarem',
   ARRAY['ba7tarem', 'bahtarem', 'ba7terem', 'ba htarem', 'ana ba7tarem'], ARRAY['بحترم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'respect'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_171', 'Core Verbs', NULL,
   171, NULL,
   'You respect (to a man)', 'بتحترم', 'bete7tarem',
   ARRAY['bete7tarem', 'betehtarem', 'bete7terem', 'enta bete7tarem'], ARRAY['بتحترم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'respect'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_172', 'Core Verbs', NULL,
   172, NULL,
   'You respect (to a woman)', 'بتحترمي', 'bete7taremi',
   ARRAY['bete7taremi', 'betehturemi', 'bete7teremi', 'enti bete7taremi'], ARRAY['بتحترمي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'respect'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_173', 'Core Verbs', NULL,
   173, NULL,
   'He respects', 'بيحترم', 'beye7tarem',
   ARRAY['beye7tarem', 'beyehtarem', 'beye7terem', 'howa beye7tarem'], ARRAY['بيحترم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'respect'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_174', 'Core Verbs', NULL,
   174, NULL,
   'She respects', 'بتحترم', 'bete7tarem',
   ARRAY['bete7tarem', 'betehtarem', 'heya bete7tarem'], ARRAY['بتحترم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'respect'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_175', 'Core Verbs', NULL,
   175, NULL,
   'We respect', 'بنحترم', 'bene7tarem',
   ARRAY['bene7tarem', 'benehtarem', 'bene7terem', 'ehna bene7tarem'], ARRAY['بنحترم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'respect'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_176', 'Core Verbs', NULL,
   176, NULL,
   'They respect', 'بيحترموا', 'beye7taremo',
   ARRAY['beye7taremo', 'beyehtaremo', 'beye7teremo', 'homma beye7taremo'], ARRAY['بيحترموا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'respect'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_001', 'Political Debate Expressions', NULL,
   1, NULL,
   'I disagree', 'بختلف', 'bakhtalef',
   ARRAY['bakhtalef', 'bakhtalif', 'ba khtalef'], ARRAY['بختلف'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'disagree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_002', 'Political Debate Expressions', NULL,
   2, NULL,
   'I agree', 'بتفق', 'bettefe2',
   ARRAY['bettefe2', 'bettef2', 'bettefe'], ARRAY['بتفق'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'agree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_003', 'Political Debate Expressions', NULL,
   3, NULL,
   'I debate', 'بناقش', 'benaa2esh',
   ARRAY['benaa2esh', 'benaaqesh', 'bena2esh', 'benaesh'], ARRAY['بناقش'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'debate'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_004', 'Political Debate Expressions', NULL,
   4, NULL,
   'I explain', 'بشرح', 'bashra7',
   ARRAY['bashra7', 'bashrakh', 'bashrach', 'bashrah'], ARRAY['بشرح'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'explain'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_005', 'Political Debate Expressions', NULL,
   5, NULL,
   'I analyse', 'بحلل', 'ba7allel',
   ARRAY['ba7allel', 'baallel', 'ba hallel'], ARRAY['بحلل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'analyse'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_006', 'Political Debate Expressions', NULL,
   6, NULL,
   'I criticise', 'بنتقد', 'bent2ed',
   ARRAY['bent2ed', 'bentqed', 'bente2ed'], ARRAY['بنتقد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'criticise'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_007', 'Political Debate Expressions', NULL,
   7, NULL,
   'I support', 'بدعم', 'bada3am',
   ARRAY['bada3am', 'badaam', 'bada am'], ARRAY['بدعم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'support'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_008', 'Political Debate Expressions', NULL,
   8, NULL,
   'I oppose', 'بعارض', 'ba3aared',
   ARRAY['ba3aared', 'baaared', 'ba3ared'], ARRAY['بعارض'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'oppose'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_009', 'Political Debate Expressions', NULL,
   9, NULL,
   'I believe', 'بصدق', 'basadda2',
   ARRAY['basadda2', 'basaddaq', 'basadda'], ARRAY['بصدق'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'believe'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_010', 'Political Debate Expressions', NULL,
   10, NULL,
   'I doubt', 'بشك', 'bashokk',
   ARRAY['bashokk', 'bashok', 'ba shokk'], ARRAY['بشك'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'doubt'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_011', 'Political Debate Expressions', NULL,
   11, NULL,
   'I influence', 'بأثر', 'ba2assar',
   ARRAY['ba2assar', 'baassar', 'ba assar'], ARRAY['بأثر'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'influence'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_012', 'Political Debate Expressions', NULL,
   12, NULL,
   'I respect', 'بحترم', 'ba7tarem',
   ARRAY['ba7tarem', 'bahtarem', 'ba htarem'], ARRAY['بحترم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'respect'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_177', 'Core Verbs', NULL,
   177, NULL,
   'I understand (f)', 'فاهمة', 'fahma',
   ARRAY['fahma', 'fahmeh', 'fahmah', 'ana fahma'], ARRAY['فاهمة'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'understand'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_178', 'Core Verbs', NULL,
   178, NULL,
   'I understand (m)', 'فاهم', 'fahem',
   ARRAY['fahem', 'fahim', 'fahm', 'ana fahem'], ARRAY['فاهم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'understand'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_179', 'Core Verbs', NULL,
   179, NULL,
   'You understand (to a man)', 'فاهم', 'fahem',
   ARRAY['fahem', 'fahim', 'enta fahem'], ARRAY['فاهم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'understand'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_180', 'Core Verbs', NULL,
   180, NULL,
   'You understand (to a woman)', 'فاهمة', 'fahma',
   ARRAY['fahma', 'fahmah', 'enti fahma'], ARRAY['فاهمة'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'understand'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_181', 'Core Verbs', NULL,
   181, NULL,
   'He understands', 'فاهم', 'fahem',
   ARRAY['fahem', 'fahim', 'howa fahem'], ARRAY['فاهم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'understand'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_182', 'Core Verbs', NULL,
   182, NULL,
   'She understands', 'فاهمة', 'fahma',
   ARRAY['fahma', 'fahmah', 'heya fahma'], ARRAY['فاهمة'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'understand'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_183', 'Core Verbs', NULL,
   183, NULL,
   'We understand', 'فاهمين', 'fahmeen',
   ARRAY['fahmeen', 'fahmin', 'fahmeyn', 'ehna fahmeen'], ARRAY['فاهمين'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'understand'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_184', 'Core Verbs', NULL,
   184, NULL,
   'They understand', 'فاهمين', 'fahmeen',
   ARRAY['fahmeen', 'fahmin', 'homma fahmeen'], ARRAY['فاهمين'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'understand'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_052', 'Top 50 Essentials', NULL,
   52, NULL,
   'Wait a minute', 'ثانية واحدة', 'sanya wa7da',
   ARRAY['sanya wa7da', 'sanya wahda', 'thanya wahda'], ARRAY['ثانية واحدة', 'ثانية وحدة'],
   '{"ar":"","en":""}'::jsonb, ARRAY['essentials', 'communication'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_055', 'Top 50 Essentials', NULL,
   55, NULL,
   'How much is this?', 'بكام ده؟', 'bekam da',
   ARRAY['bekam da', 'bi kam dah', 'bekam dah'], ARRAY['بكام ده؟', 'بكام ده'],
   '{"ar":"","en":""}'::jsonb, ARRAY['essentials', 'questions'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_013', 'Political Debate Expressions', NULL,
   13, NULL,
   'In my opinion', 'في رأيي', 'fi ra2yi',
   ARRAY['fi ra2yi', 'fee rayee', 'fi rayi'], ARRAY['في رأيي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'opinion'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_014', 'Political Debate Expressions', NULL,
   14, NULL,
   'I''m convinced', 'أنا مقتنع', 'ana moqtane3',
   ARRAY['ana moqtane3', 'ana moqtaneh', 'ana moqtana3'], ARRAY['أنا مقتنع'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'opinion'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_015', 'Political Debate Expressions', NULL,
   15, NULL,
   'From my perspective', 'من وجهة نظري', 'men weget nazari',
   ARRAY['men weget nazari', 'min wighet nazari', 'men weghet nazary'], ARRAY['من وجهة نظري'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'opinion'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_016', 'Political Debate Expressions', NULL,
   16, NULL,
   'Actually', 'في الحقيقة', 'fel 7aqeeqa',
   ARRAY['fel 7aqeeqa', 'fil haqiqa', 'fel haqeeqa'], ARRAY['في الحقيقة'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'opinion'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_017', 'Political Debate Expressions', NULL,
   17, NULL,
   'It depends', 'على حسب', '3ala 7asab',
   ARRAY['3ala 7asab', 'ala hasab', 'ala hassab'], ARRAY['على حسب'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'opinion'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_018', 'Political Debate Expressions', NULL,
   18, NULL,
   'That''s impossible', 'ده مستحيل', 'da mosta7eel',
   ARRAY['da mosta7eel', 'da mostahil', 'dah mostaheel'], ARRAY['ده مستحيل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'disagree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_019', 'Political Debate Expressions', NULL,
   19, NULL,
   'I don''t think so', 'ماظنش', 'mazonnesh',
   ARRAY['mazonnesh', 'ma zonish', 'mazonish', 'mazonesh'], ARRAY['ماظنش', 'ما أظنش'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'disagree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_020', 'Political Debate Expressions', ARRAY['Top 50 Essentials'],
   20, NULL,
   'Exactly', 'بالظبط', 'bezzabt',
   ARRAY['bezzabt', 'bilzabt', 'bel zabt'], ARRAY['بالظبط'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'agree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_185', 'Core Verbs', NULL,
   185, NULL,
   'I speak (f)', 'بتكلم', 'batkelem',
   ARRAY['batkelem', 'batkallam', 'batkalem', 'ana batkelem'], ARRAY['بتكلم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'speak'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_186', 'Core Verbs', NULL,
   186, NULL,
   'I speak (m)', 'بتكلم', 'batkelem',
   ARRAY['batkelem', 'batkallam', 'batkalem', 'ana batkelem'], ARRAY['بتكلم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'speak'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_187', 'Core Verbs', NULL,
   187, NULL,
   'You speak (to a man)', 'بتتكلم', 'betetkelem',
   ARRAY['betetkelem', 'btetkelem', 'bititkallam', 'enta betetkelem'], ARRAY['بتتكلم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'speak'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_188', 'Core Verbs', NULL,
   188, NULL,
   'You speak (to a woman)', 'بتتكلمي', 'betetkelemi',
   ARRAY['betetkelemi', 'btetkelemy', 'bititkallemi', 'enti betetkelemi'], ARRAY['بتتكلمي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'speak'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_189', 'Core Verbs', NULL,
   189, NULL,
   'He speaks', 'بيتكلم', 'beyetkelem',
   ARRAY['beyetkelem', 'byetkelem', 'beyitkallam', 'howa beyetkelem'], ARRAY['بيتكلم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'speak'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_190', 'Core Verbs', NULL,
   190, NULL,
   'She speaks', 'بتتكلم', 'betetkelem',
   ARRAY['betetkelem', 'btetkelem', 'bititkallam', 'heya betetkelem'], ARRAY['بتتكلم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'speak'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_191', 'Core Verbs', NULL,
   191, NULL,
   'We speak', 'بنتكلم', 'benetkelem',
   ARRAY['benetkelem', 'bnetkelem', 'benitkallam', 'ehna benetkelem'], ARRAY['بنتكلم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'speak'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_192', 'Core Verbs', NULL,
   192, NULL,
   'They speak', 'بيتكلموا', 'beyetkelemo',
   ARRAY['beyetkelemo', 'byetkelemo', 'beyitkallemu', 'homma beyetkelemo'], ARRAY['بيتكلموا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'speak'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_193', 'Core Verbs', NULL,
   193, NULL,
   'I help (f)', 'بساعد', 'basa3ed',
   ARRAY['basa3ed', 'besa3ed', 'basaed', 'ana basa3ed'], ARRAY['بساعد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'help'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_194', 'Core Verbs', NULL,
   194, NULL,
   'I help (m)', 'بساعد', 'basa3ed',
   ARRAY['basa3ed', 'besa3ed', 'basaed', 'ana basa3ed'], ARRAY['بساعد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'help'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_195', 'Core Verbs', NULL,
   195, NULL,
   'You help (to a man)', 'بتساعد', 'betesa3ed',
   ARRAY['betesa3ed', 'btesa3ed', 'bitisaed', 'enta betesa3ed'], ARRAY['بتساعد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'help'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_196', 'Core Verbs', NULL,
   196, NULL,
   'You help (to a woman)', 'بتساعدي', 'betesa3di',
   ARRAY['betesa3di', 'btesa3dy', 'bitisaedi', 'enti betesa3di'], ARRAY['بتساعدي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'help'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_197', 'Core Verbs', NULL,
   197, NULL,
   'He helps', 'بيساعد', 'beyesa3ed',
   ARRAY['beyesa3ed', 'byesaed', 'biyisaed', 'howa beyesa3ed'], ARRAY['بيساعد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'help'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_198', 'Core Verbs', NULL,
   198, NULL,
   'She helps', 'بتساعد', 'betesa3ed',
   ARRAY['betesa3ed', 'btesa3ed', 'bitisaed', 'heya betesa3ed'], ARRAY['بتساعد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'help'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_199', 'Core Verbs', NULL,
   199, NULL,
   'We help', 'بنساعد', 'benesa3ed',
   ARRAY['benesa3ed', 'bnesa3ed', 'binisaed', 'ehna benesa3ed'], ARRAY['بنساعد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'help'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_200', 'Core Verbs', NULL,
   200, NULL,
   'They help', 'بيساعدوا', 'beyesa3do',
   ARRAY['beyesa3do', 'byesa3du', 'biyisaedu', 'homma beyesa3do'], ARRAY['بيساعدوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'help'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_201', 'Core Verbs', NULL,
   201, NULL,
   'I start (f)', 'ببدأ', 'babda2',
   ARRAY['babda2', 'babda', 'babdaah', 'ana babda2'], ARRAY['ببدأ'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'start'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_202', 'Core Verbs', NULL,
   202, NULL,
   'I start (m)', 'ببدأ', 'babda2',
   ARRAY['babda2', 'babda', 'babdah', 'ana babda2'], ARRAY['ببدأ'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'start'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_203', 'Core Verbs', NULL,
   203, NULL,
   'You start (to a man)', 'بتبدأ', 'betebda2',
   ARRAY['betebda2', 'btibda', 'betibdah', 'enta betebda2'], ARRAY['بتبدأ'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'start'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_204', 'Core Verbs', NULL,
   204, NULL,
   'You start (to a woman)', 'بتبدأي', 'betebda2i',
   ARRAY['betebda2i', 'btibdai', 'betibda2i', 'enti betebda2i'], ARRAY['بتبدأي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'start'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_205', 'Core Verbs', NULL,
   205, NULL,
   'He starts', 'بيبدأ', 'beyebda2',
   ARRAY['beyebda2', 'byebda', 'biyibda', 'howa beyebda2'], ARRAY['بيبدأ'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'start'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_206', 'Core Verbs', NULL,
   206, NULL,
   'She starts', 'بتبدأ', 'betebda2',
   ARRAY['betebda2', 'btebda', 'bitibda', 'heya betebda2'], ARRAY['بتبدأ'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'start'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_207', 'Core Verbs', NULL,
   207, NULL,
   'We start', 'بنبدأ', 'benebda2',
   ARRAY['benebda2', 'bnebda', 'binibda', 'ehna benebda2'], ARRAY['بنبدأ'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'start'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_208', 'Core Verbs', NULL,
   208, NULL,
   'They start', 'بيبدأوا', 'beyebda2o',
   ARRAY['beyebda2o', 'byebdao', 'biyibda2u', 'homma beyebda2o'], ARRAY['بيبدأوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'start'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_209', 'Core Verbs', NULL,
   209, NULL,
   'I try (f)', 'بحاول', 'ba7awel',
   ARRAY['ba7awel', 'bahawel', 'bahawil', 'ana ba7awel'], ARRAY['بحاول'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'try'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_210', 'Core Verbs', NULL,
   210, NULL,
   'I try (m)', 'بحاول', 'ba7awel',
   ARRAY['ba7awel', 'bahawel', 'bahawil', 'ana ba7awel'], ARRAY['بحاول'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'try'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_211', 'Core Verbs', NULL,
   211, NULL,
   'You try (to a man)', 'بتحاول', 'bete7awel',
   ARRAY['bete7awel', 'bt7awel', 'bet-hawel', 'enta bete7awel'], ARRAY['بتحاول'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'try'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_212', 'Core Verbs', NULL,
   212, NULL,
   'You try (to a woman)', 'بتحاولي', 'bete7awli',
   ARRAY['bete7awli', 'bt7awly', 'bet-hawli', 'enti bete7awli'], ARRAY['بتحاولي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'try'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_213', 'Core Verbs', NULL,
   213, NULL,
   'He tries', 'بيحاول', 'beye7awel',
   ARRAY['beye7awel', 'by7awel', 'biy-hawel', 'howa beye7awel'], ARRAY['بيحاول'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'try'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_214', 'Core Verbs', NULL,
   214, NULL,
   'She tries', 'بتحاول', 'bete7awel',
   ARRAY['bete7awel', 'bt7awel', 'bet-hawel', 'heya bete7awel'], ARRAY['بتحاول'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'try'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_215', 'Core Verbs', NULL,
   215, NULL,
   'We try', 'بنحاول', 'bene7awel',
   ARRAY['bene7awel', 'bn7awel', 'ben-hawel', 'ehna bene7awel'], ARRAY['بنحاول'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'try'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_216', 'Core Verbs', NULL,
   216, NULL,
   'They try', 'بيحاولوا', 'beye7awlo',
   ARRAY['beye7awlo', 'by7awlu', 'biy-hawlo', 'homma beye7awlo'], ARRAY['بيحاولوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'try'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_217', 'Core Verbs', NULL,
   217, NULL,
   'I live / stay (f)', 'قاعدة', '2a3da',
   ARRAY['2a3da', 'aada', 'aqda', 'ana 2a3da'], ARRAY['قاعدة'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'stay'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_218', 'Core Verbs', NULL,
   218, NULL,
   'I live / stay (m)', 'قاعد', '2a3ed',
   ARRAY['2a3ed', 'aaed', 'aqed', 'ana 2a3ed'], ARRAY['قاعد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'stay'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_219', 'Core Verbs', NULL,
   219, NULL,
   'You live / stay (to a man)', 'قاعد', '2a3ed',
   ARRAY['2a3ed', 'aaed', 'enta 2a3ed'], ARRAY['قاعد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'stay'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_220', 'Core Verbs', NULL,
   220, NULL,
   'You live / stay (to a woman)', 'قاعدة', '2a3da',
   ARRAY['2a3da', 'aada', 'enti 2a3da'], ARRAY['قاعدة'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'stay'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_221', 'Core Verbs', NULL,
   221, NULL,
   'He lives / stays', 'قاعد', '2a3ed',
   ARRAY['2a3ed', 'aaed', 'howa 2a3ed'], ARRAY['قاعد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'stay'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_222', 'Core Verbs', NULL,
   222, NULL,
   'She lives / stays', 'قاعدة', '2a3da',
   ARRAY['2a3da', 'aada', 'heya 2a3da'], ARRAY['قاعدة'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'stay'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_223', 'Core Verbs', NULL,
   223, NULL,
   'We live / stay', 'قاعدين', '2a3deen',
   ARRAY['2a3deen', 'aadeen', 'ehna 2a3deen'], ARRAY['قاعدين'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'stay'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_224', 'Core Verbs', NULL,
   224, NULL,
   'They live / stay', 'قاعدين', '2a3deen',
   ARRAY['2a3deen', 'aadeen', 'homma 2a3deen'], ARRAY['قاعدين'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'stay'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_225', 'Core Verbs', NULL,
   225, NULL,
   'I forget (f)', 'بنسى', 'bansa',
   ARRAY['bansa', 'bensa', 'banza', 'ana bansa'], ARRAY['بنسى'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'forget'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_226', 'Core Verbs', NULL,
   226, NULL,
   'I forget (m)', 'بنسى', 'bansa',
   ARRAY['bansa', 'bensa', 'banza', 'ana bansa'], ARRAY['بنسى'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'forget'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_227', 'Core Verbs', NULL,
   227, NULL,
   'You forget (to a man)', 'بتنسى', 'betensa',
   ARRAY['betensa', 'btensa', 'bitinsa', 'enta betensa'], ARRAY['بتنسى'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'forget'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_228', 'Core Verbs', NULL,
   228, NULL,
   'You forget (to a woman)', 'بتنسي', 'betensi',
   ARRAY['betensi', 'btensy', 'bitinsi', 'enti betensi'], ARRAY['بتنسي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'forget'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_229', 'Core Verbs', NULL,
   229, NULL,
   'He forgets', 'بينسى', 'beyensa',
   ARRAY['beyensa', 'byensa', 'biyinsa', 'howa beyensa'], ARRAY['بينسى'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'forget'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_230', 'Core Verbs', NULL,
   230, NULL,
   'She forgets', 'بتنسى', 'betensa',
   ARRAY['betensa', 'btensa', 'bitinsa', 'heya betensa'], ARRAY['بتنسى'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'forget'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_231', 'Core Verbs', NULL,
   231, NULL,
   'We forget', 'بننسى', 'benensa',
   ARRAY['benensa', 'bnensa', 'bininsa', 'ehna benensa'], ARRAY['بننسى'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'forget'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_232', 'Core Verbs', NULL,
   232, NULL,
   'They forget', 'بينسوا', 'beyenso',
   ARRAY['beyenso', 'byenso', 'biyensu', 'homma beyenso'], ARRAY['بينسوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'forget'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_233', 'Core Verbs', NULL,
   233, NULL,
   'I walk (f)', 'بمشي', 'bamshi',
   ARRAY['bamshi', 'bamshy', 'bemshi', 'ana bamshi'], ARRAY['بمشي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'walk'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_234', 'Core Verbs', NULL,
   234, NULL,
   'I walk (m)', 'بمشي', 'bamshi',
   ARRAY['bamshi', 'bamshy', 'bemshi', 'ana bamshi'], ARRAY['بمشي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'walk'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_235', 'Core Verbs', NULL,
   235, NULL,
   'You walk (to a man)', 'بتمشي', 'betemshi',
   ARRAY['betemshi', 'btemshi', 'bitimshi', 'enta betemshi'], ARRAY['بتمشي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'walk'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_236', 'Core Verbs', NULL,
   236, NULL,
   'You walk (to a woman)', 'بتمشي', 'betemshi',
   ARRAY['betemshi', 'btemshi', 'bitimshi', 'enti betemshi'], ARRAY['بتمشي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'walk'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_237', 'Core Verbs', NULL,
   237, NULL,
   'He walks', 'بيمشي', 'beyemshi',
   ARRAY['beyemshi', 'byemshi', 'biyimshi', 'howa beyemshi'], ARRAY['بيمشي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'walk'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_238', 'Core Verbs', NULL,
   238, NULL,
   'She walks', 'بتمشي', 'betemshi',
   ARRAY['betemshi', 'btemshi', 'bitimshi', 'heya betemshi'], ARRAY['بتمشي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'walk'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_239', 'Core Verbs', NULL,
   239, NULL,
   'We walk', 'بنمشي', 'benemshi',
   ARRAY['benemshi', 'bnemshi', 'binimshi', 'ehna benemshi'], ARRAY['بنمشي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'walk'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_240', 'Core Verbs', NULL,
   240, NULL,
   'They walk', 'بيمشوا', 'beyemsho',
   ARRAY['beyemsho', 'byemshu', 'biyimsho', 'homma beyemsho'], ARRAY['بيمشوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'walk'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_056', 'Family Members', NULL,
   1, NULL,
   'Dad / Father', 'بابا', 'baba',
   ARRAY['baba', 'abb', 'ab', 'abo'], ARRAY['بابا', 'أب'],
   '{"ar":"","en":""}'::jsonb, ARRAY['family', 'family-members'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_057', 'Family Members', NULL,
   2, NULL,
   'Mum / Mother', 'ماما', 'mama',
   ARRAY['mama', 'omm', 'om', 'um'], ARRAY['ماما', 'أم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['family', 'family-members'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_058', 'Family Members', NULL,
   3, NULL,
   'Grandpa', 'جد', 'gedd',
   ARRAY['gedd', 'ged', 'jid'], ARRAY['جد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['family', 'family-members'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_059', 'Family Members', NULL,
   4, NULL,
   'Grandma', 'جدة', 'gedda',
   ARRAY['gedda', 'geddah', 'jidda'], ARRAY['جدة'],
   '{"ar":"","en":""}'::jsonb, ARRAY['family', 'family-members'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_060', 'Family Members', NULL,
   5, NULL,
   'Cousin (m, paternal)', 'ابن عم', 'ebn 3amm',
   ARRAY['ebn 3amm', 'ebn am', 'ibn amm'], ARRAY['ابن عم'],
   '{"ar":"","en":""}'::jsonb, ARRAY['family', 'family-members'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_061', 'Food & Drink', NULL,
   1, NULL,
   'Egyptian flatbread', 'عيش بلدي', '3eish baladi',
   ARRAY['3eish baladi', 'eish baladi', 'aysh balady'], ARRAY['عيش بلدي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['food', 'food-items'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_062', 'Food & Drink', NULL,
   2, NULL,
   'Koshari', 'كشري', 'koshari',
   ARRAY['koshari', 'kushari', 'koshary'], ARRAY['كشري'],
   '{"ar":"","en":""}'::jsonb, ARRAY['food', 'food-items'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_063', 'Food & Drink', NULL,
   3, NULL,
   'Ta3meya (Falafel)', 'طعمية', 'ta3meya',
   ARRAY['ta3meya', 'tamya', 'tameya'], ARRAY['طعمية'],
   '{"ar":"","en":""}'::jsonb, ARRAY['food', 'food-items'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_064', 'Food & Drink', NULL,
   4, NULL,
   'Ful (Fava Beans)', 'فول', 'foul',
   ARRAY['foul', 'ful', 'fool'], ARRAY['فول'],
   '{"ar":"","en":""}'::jsonb, ARRAY['food', 'food-items'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_065', 'Food & Drink', NULL,
   5, NULL,
   'Salad', 'سلطة', 'salata',
   ARRAY['salata', 'salatah', 'solata'], ARRAY['سلطة'],
   '{"ar":"","en":""}'::jsonb, ARRAY['food', 'food-items'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('phrase_001', 'Common Phrases', NULL,
   1, NULL,
   'By the way', 'على فكرة', '3ala fekra',
   ARRAY['3ala fekra', 'ala fekra', 'ala fikra'], ARRAY['على فكرة'],
   '{"ar":"","en":""}'::jsonb, ARRAY['phrases', 'conversation'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('phrase_002', 'Common Phrases', NULL,
   2, NULL,
   'Anyway', 'على أي حال', '3ala ay 7aal',
   ARRAY['3ala ay 7aal', 'ala ay hal', 'ala ayy hal'], ARRAY['على أي حال'],
   '{"ar":"","en":""}'::jsonb, ARRAY['phrases', 'conversation'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('phrase_003', 'Common Phrases', NULL,
   3, NULL,
   'The thing is...', 'الموضوع إن', 'el mawdou3 en',
   ARRAY['el mawdou3 en', 'el mawdo3 en', 'al mawdu3 in'], ARRAY['الموضوع إن'],
   '{"ar":"","en":""}'::jsonb, ARRAY['phrases', 'conversation'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('phrase_004', 'Common Phrases', NULL,
   4, NULL,
   'Take your time', 'خد وقتك', 'khod wa2tak',
   ARRAY['khod wa2tak', 'khod waktak', 'khud waktak'], ARRAY['خد وقتك'],
   '{"ar":"","en":""}'::jsonb, ARRAY['phrases', 'social'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('phrase_005', 'Common Phrases', NULL,
   5, NULL,
   'Welcome / Please come in', 'اتفضل', 'etfaddal',
   ARRAY['etfaddal', 'itfaddal', 'atfaddal'], ARRAY['اتفضل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['phrases', 'social'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('phrase_006', 'Common Phrases', NULL,
   6, NULL,
   'Don''t worry', 'ما تقلقش', 'ma te2la2sh',
   ARRAY['ma te2la2sh', 'ma teklaksh', 'ma tilaqsh'], ARRAY['ما تقلقش'],
   '{"ar":"","en":""}'::jsonb, ARRAY['phrases', 'social'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('phrase_007', 'Common Phrases', NULL,
   7, NULL,
   'On my way', 'في السكة', 'fes-sekka',
   ARRAY['fes-sekka', 'fel sekka', 'fis-sikka'], ARRAY['في السكة'],
   '{"ar":"","en":""}'::jsonb, ARRAY['phrases', 'transport'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('phrase_008', 'Common Phrases', NULL,
   8, NULL,
   'Call me', 'كلمني', 'kallemni',
   ARRAY['kallemni', 'kallemny'], ARRAY['كلمني'],
   '{"ar":"","en":""}'::jsonb, ARRAY['phrases', 'social'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_021', 'Political Debate Expressions', NULL,
   21, NULL,
   'I see your point but...', 'أنا فاهم وجهة نظرك بس', 'ana fahem weget nazarak bas',
   ARRAY['ana fahem weget nazarak bas', 'ana fahem wighet nazarak bas', 'ana fahim wighet nazarak bas'], ARRAY['أنا فاهم وجهة نظرك بس'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'disagree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_022', 'Political Debate Expressions', NULL,
   22, NULL,
   'Fair enough', 'حقك عليّ', '7aqqak 3alaya',
   ARRAY['7aqqak 3alaya', 'haqqak alaya', 'hakak alaya'], ARRAY['حقك عليّ', 'حقك عليا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'agree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_023', 'Political Debate Expressions', NULL,
   23, NULL,
   'What I mean is', 'قصدي إن', 'asdi en',
   ARRAY['asdi en', '2asdi en', 'qasdi in'], ARRAY['قصدي إن'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'opinion'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_024', 'Political Debate Expressions', NULL,
   24, NULL,
   'Absolutely not', 'مستحيل طبعاً', 'mosta7eel tab3an',
   ARRAY['mosta7eel tab3an', 'mostahil taban'], ARRAY['مستحيل طبعاً'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'disagree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_025', 'Political Debate Expressions', NULL,
   25, NULL,
   'Without a doubt', 'من غير شك', 'men gheir shakk',
   ARRAY['men gheir shakk', 'min gher shak'], ARRAY['من غير شك'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'agree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_026', 'Political Debate Expressions', NULL,
   26, NULL,
   'Be honest', 'خليك صريح', 'khalleek saree7',
   ARRAY['khalleek saree7', 'khallik sarih'], ARRAY['خليك صريح'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'opinion'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_027', 'Political Debate Expressions', NULL,
   27, NULL,
   'Think about it', 'فكر فيها', 'fakkar feeha',
   ARRAY['fakkar feeha', 'fakar fiha'], ARRAY['فكر فيها'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'opinion'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_028', 'Political Debate Expressions', NULL,
   28, NULL,
   'Furthermore', 'غير كدة كمان', 'gheir keda kaman',
   ARRAY['gheir keda kaman', 'gher keda kaman'], ARRAY['غير كدة كمان'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'opinion'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_241', 'Core Verbs', NULL,
   241, NULL,
   'I take (f)', 'باخد', 'baakhod',
   ARRAY['baakhod', 'bakhod', 'ba''akhod', 'ana baakhod'], ARRAY['باخد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'take'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_242', 'Core Verbs', NULL,
   242, NULL,
   'I take (m)', 'باخد', 'baakhod',
   ARRAY['baakhod', 'bakhod', 'ba''akhod', 'ana baakhod'], ARRAY['باخد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'take'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_243', 'Core Verbs', NULL,
   243, NULL,
   'You take (to a man)', 'بتاخد', 'betaakhod',
   ARRAY['betaakhod', 'betakhod', 'btakhod', 'enta betaakhod'], ARRAY['بتاخد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'take'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_244', 'Core Verbs', NULL,
   244, NULL,
   'You take (to a woman)', 'بتاخدي', 'betaakhdi',
   ARRAY['betaakhdi', 'betakhdi', 'btakhdy', 'enti betaakhdi'], ARRAY['بتاخدي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'take'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_245', 'Core Verbs', NULL,
   245, NULL,
   'He takes', 'بياخد', 'beyaakhod',
   ARRAY['beyaakhod', 'byakhod', 'biyakhod', 'howa beyaakhod'], ARRAY['بياخد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'take'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_246', 'Core Verbs', NULL,
   246, NULL,
   'She takes', 'بتاخد', 'betaakhod',
   ARRAY['betaakhod', 'betakhod', 'btakhod', 'heya betaakhod'], ARRAY['بتاخد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'take'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_247', 'Core Verbs', NULL,
   247, NULL,
   'We take', 'بناخد', 'benaakhod',
   ARRAY['benaakhod', 'benakhod', 'bnakhod', 'ehna benaakhod'], ARRAY['بناخد'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'take'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_248', 'Core Verbs', NULL,
   248, NULL,
   'They take', 'بياخدوا', 'beyaakhdo',
   ARRAY['beyaakhdo', 'byakhdo', 'biyakhdu', 'homma beyaakhdo'], ARRAY['بياخدوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'take'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_249', 'Core Verbs', NULL,
   249, NULL,
   'I meet (f)', 'بقابل', 'ba2abel',
   ARRAY['ba2abel', 'baqabel', 'bakabel', 'ana ba2abel'], ARRAY['بقابل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'meet'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_250', 'Core Verbs', NULL,
   250, NULL,
   'I meet (m)', 'بقابل', 'ba2abel',
   ARRAY['ba2abel', 'baqabel', 'bakabel', 'ana ba2abel'], ARRAY['بقابل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'meet'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_251', 'Core Verbs', NULL,
   251, NULL,
   'You meet (to a man)', 'بتقابل', 'bete2abel',
   ARRAY['bete2abel', 'betqabel', 'bt2abel', 'enta bete2abel'], ARRAY['بتقابل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'meet'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_252', 'Core Verbs', NULL,
   252, NULL,
   'You meet (to a woman)', 'بتقابلي', 'bete2abli',
   ARRAY['bete2abli', 'betqabli', 'bt2ably', 'enti bete2abli'], ARRAY['بتقابلي'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'meet'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_253', 'Core Verbs', NULL,
   253, NULL,
   'He meets', 'بيقابل', 'beye2abel',
   ARRAY['beye2abel', 'byqabel', 'biy2abel', 'howa beye2abel'], ARRAY['بيقابل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'meet'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_254', 'Core Verbs', NULL,
   254, NULL,
   'She meets', 'بتقابل', 'bete2abel',
   ARRAY['bete2abel', 'betqabel', 'btqabel', 'heya bete2abel'], ARRAY['بتقابل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'meet'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_255', 'Core Verbs', NULL,
   255, NULL,
   'We meet', 'بنقابل', 'bene2abel',
   ARRAY['bene2abel', 'benqabel', 'bn2abel', 'ehna bene2abel'], ARRAY['بنقابل'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'meet'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('verb_256', 'Core Verbs', NULL,
   256, NULL,
   'They meet', 'بيقابلوا', 'beye2ablo',
   ARRAY['beye2ablo', 'byqablo', 'biy2ablu', 'homma beye2ablo'], ARRAY['بيقابلوا'],
   '{"ar":"","en":""}'::jsonb, ARRAY['verbs', 'meet'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_066', 'Places & Directions', NULL,
   1, NULL,
   'Building', 'عمارة', '3emara',
   ARRAY['3emara', 'emara', 'imara', 'amara'], ARRAY['عمارة'],
   '{"ar":"","en":""}'::jsonb, ARRAY['places', 'locations'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_067', 'Places & Directions', NULL,
   2, NULL,
   'Upstairs', 'فوق', 'fo2',
   ARRAY['fo2', 'foq', 'fou2', 'fok'], ARRAY['فوق'],
   '{"ar":"","en":""}'::jsonb, ARRAY['places', 'directions'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_068', 'Places & Directions', NULL,
   3, NULL,
   'Downstairs', 'تحت', 'ta7t',
   ARRAY['ta7t', 'taht', 'tahet'], ARRAY['تحت'],
   '{"ar":"","en":""}'::jsonb, ARRAY['places', 'directions'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_069', 'Places & Directions', NULL,
   4, NULL,
   'Airport', 'مطار', 'mataar',
   ARRAY['mataar', 'matar'], ARRAY['مطار'],
   '{"ar":"","en":""}'::jsonb, ARRAY['places', 'locations'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_070', 'Food & Drink', NULL,
   6, NULL,
   'Juice', 'عصير', '3aseer',
   ARRAY['3aseer', 'aseer', 'asir', 'azeer'], ARRAY['عصير'],
   '{"ar":"","en":""}'::jsonb, ARRAY['food', 'food-items'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_071', 'Food & Drink', NULL,
   7, NULL,
   'Pasta', 'مكرونة', 'makarona',
   ARRAY['makarona', 'macarona', 'makaronah'], ARRAY['مكرونة'],
   '{"ar":"","en":""}'::jsonb, ARRAY['food', 'food-items'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('card_072', 'Food & Drink', NULL,
   8, NULL,
   'Fruit', 'فاكهة', 'fakha',
   ARRAY['fakha', 'fakya', 'fakeha', 'fakyah'], ARRAY['فاكهة'],
   '{"ar":"","en":""}'::jsonb, ARRAY['food', 'food-items'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('phrase_009', 'Common Phrases', NULL,
   9, NULL,
   'As you wish', 'زي ما تحب', 'zay ma te7ebb',
   ARRAY['zay ma te7ebb', 'zay ma tehebb', 'zy ma thib'], ARRAY['زي ما تحب'],
   '{"ar":"","en":""}'::jsonb, ARRAY['phrases', 'social'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('phrase_010', 'Common Phrases', NULL,
   10, NULL,
   'Make yourself at home', 'البيت بيتك', 'el beit beitak',
   ARRAY['el beit beitak', 'al bet betak', 'el bayt baytak'], ARRAY['البيت بيتك'],
   '{"ar":"","en":""}'::jsonb, ARRAY['phrases', 'social'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('phrase_011', 'Common Phrases', NULL,
   11, NULL,
   'It was delicious', 'كان طعمه تحفة', 'kan ta3mo to7fa',
   ARRAY['kan ta3mo to7fa', 'kan tamo tohfa', 'kan tamu tohfah'], ARRAY['كان طعمه تحفة'],
   '{"ar":"","en":""}'::jsonb, ARRAY['phrases', 'social'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('phrase_012', 'Common Phrases', NULL,
   12, NULL,
   'Honestly speaking', 'بصراحة كدة', 'be sara7a keda',
   ARRAY['be sara7a keda', 'bi saraha keda', 'besaraha kidah'], ARRAY['بصراحة كدة'],
   '{"ar":"","en":""}'::jsonb, ARRAY['phrases', 'conversation'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_029', 'Political Debate Expressions', NULL,
   29, NULL,
   'You''re partly right', 'عندك حق في جزء', '3andak 7aq fe goz2',
   ARRAY['3andak 7aq fe goz2', 'andak haq fe goz', 'andak hak fi goz'], ARRAY['عندك حق في جزء'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'agree'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_030', 'Political Debate Expressions', NULL,
   30, NULL,
   'On the other hand', 'من ناحية تانية', 'men na7ya tanya',
   ARRAY['men na7ya tanya', 'min nahya tanya', 'men nahyah tanyah'], ARRAY['من ناحية تانية'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'opinion'], '')
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
  notes                 = EXCLUDED.notes;

INSERT INTO cards
  (id, category, additional_categories, "order", deck,
   english, arabic, transliteration, accepted, arabic_variants,
   audio, tags, notes)
VALUES
  ('pd_031', 'Political Debate Expressions', NULL,
   31, NULL,
   'Ask yourself', 'اسأل نفسك', 'es2al nafsak',
   ARRAY['es2al nafsak', 'es''al nafsak', 'isal nafsak'], ARRAY['اسأل نفسك'],
   '{"ar":"","en":""}'::jsonb, ARRAY['political-debate', 'opinion'], '')
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
  notes                 = EXCLUDED.notes;

-- Verify
SELECT COUNT(*) AS total_cards FROM cards;
