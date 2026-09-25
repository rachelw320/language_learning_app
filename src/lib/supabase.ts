import { createClient } from '@supabase/supabase-js';

const url = import.meta.env.VITE_SUPABASE_URL as string | undefined;
const anonKey = import.meta.env.VITE_SUPABASE_ANON_KEY as string | undefined;

// Without the env vars (e.g. a build with no .env) the client points at a placeholder and every request fails,
// which the rest of the app treats as "just use the bundled cards" rather than crashing
export const supabase = createClient(url ?? 'https://placeholder.supabase.co', anonKey ?? 'placeholder');
