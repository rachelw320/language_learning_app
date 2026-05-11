-- Run this in: Supabase dashboard → SQL Editor → New query

-- Stores one SRS row per user per card
CREATE TABLE IF NOT EXISTS user_progress (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  card_id       TEXT NOT NULL,
  interval_days INTEGER     NOT NULL DEFAULT 1,
  ease_factor   NUMERIC(4,2) NOT NULL DEFAULT 2.50,
  due_date      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  reps          INTEGER NOT NULL DEFAULT 0,
  lapses        INTEGER NOT NULL DEFAULT 0,
  last_reviewed TIMESTAMPTZ,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  UNIQUE(user_id, card_id)
);

-- Row-level security: users can only see their own rows
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "own_progress" ON user_progress
  FOR ALL USING (auth.uid() = user_id);
