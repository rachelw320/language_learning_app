### Egyptian Arabic flashcard app

A react and typescript pwa for learning egyptian arabic, with typed answers, fuzzy matching for transliteration, spaced repetition and audio for every card

#### Overview

It's a small web app I use on my phone. The home screen lists the categories and a mastery bar (how many of the 369 cards I've mastered so far), you pick a category and then one of three modes:

- English -> arabic: the english plays and is shown, you type the transliteration (or the arabic itself if you have an arabic keyboard)
- Arabic -> english: the arabic plays and is shown with its transliteration, you type the meaning
- Browse: search and scroll through every card in the category and tap to hear it

A session is either the whole category shuffled ("mix all") or one group from it - verb categories are grouped by verb so you get every conjugation of "go" together, and the others are grouped by topic. Progress is saved on the device, there are no accounts.

#### Why I built it

A lot of the language apps I looked at for arabic switch to modern standard arabic (msa) or to other dialects of arabic, and because I'm learning egyptian arabic specifically I wanted my own version, with only egyptian arabic in it and with me deciding what goes in the deck.

#### How it works

##### English -> arabic

1. The english audio plays automatically and the english is shown on screen.
2. You type the transliteration, e.g. "ya3ni eh" for يعني إيه, and press check (or enter).
3. Your answer is normalised and compared with every accepted spelling for the card using levenshtein similarity. 72% similar or better counts as correct, so "ya3ne eih" still passes
4. If it's right you see the arabic, the transliteration and a replay button, and it moves on by itself after a moment. If not, you see the answer and press next.
5. If you type arabic script instead, it's compared with the card's arabic variants, so you can answer either way.

##### Arabic -> english

1. The arabic audio plays and the arabic is shown with its transliteration under it.
2. You type the english meaning.
3. Same matching, but qualifiers in brackets like "(f)" or "(to a man)" are stripped from both sides first, so "you go" matches "you go (to a man)".

##### After a session

The summary screen shows your score and the cards you missed. From there you can try the same cards again, or review just the ones you got wrong.

##### Progress and mastery

- Every answer updates an sm-2 schedule for that card (correct counts as grade 3, wrong as grade 1, which resets it)
- Separately, a card becomes mastered after you get it right on 5 different days. Only one correct answer a day counts towards the streak, and a wrong answer resets it.
- When you get a mastered card right you can tap "don't show again for a week" and it disappears from sessions for 7 days
- All of this is stored in local storage on the device

##### Audio

Every card has an arabic and an english mp3 under public/audio, generated once with elevenlabs (the eleven_v3 model with an egyptian arabic voice) by scripts/generate-audio.js and committed to the repo, so netlify just serves them as static files with a one year cache header. The right side plays automatically when a card comes up and the speaker button replays it.

##### Cards

The deck is src/data/cards.json - 369 cards in 7 categories:

- Top 50 essentials (53)
- Core verbs (256)
- Political debate expressions (31)
- Common phrases (12)
- Food & drink (8)
- Family members (5)
- Places & directions (4)

Each card has the english, the arabic, a transliteration, a list of accepted transliteration spellings, arabic spelling variants, audio paths and tags. Verb cards have every pronoun as a separate card ("I go", "you go (f)", "he goes" and so on) and the group is labelled with the "he" form.

The same cards are also in a supabase table. The app starts with the bundled json (or the last copy it cached), then fetches from supabase and swaps that in if it works, so I can add cards without redeploying.

##### Admin screen

The + on the home screen opens a form to add a card: category, english, arabic and transliteration, and then for each language you can either hold to record the audio yourself or generate it with elevenlabs. Generation goes through a netlify function so the api key stays on the server. The audio is uploaded to a supabase storage bucket, the card is inserted into the cards table and the app reloads the deck.

#### Tech stack

- React 18 and typescript, built with vite
- Tailwind css
- Supabase (postgres for the cards table, storage for uploaded audio)
- Netlify for hosting and the serverless functions
- Elevenlabs for the audio
- Vitest for the tests, prettier for formatting, github actions to run the checks
- Pwa manifest and icons so it installs on the home screen

#### Key implementation details

- Fuzzy matching - levenshtein distance turned into a 0 to 1 similarity, best score across all the accepted variants, pass threshold 0.72. In src/lib/matching.ts
- Transliteration normalisation - lowercased, apostrophes removed, ph -> f, ck -> k, oo -> u, ei -> e, ai -> a, then everything except letters, spaces, 2 and 3 is dropped (2 and 3 are the chat arabic letters for ء and ع). So "ya3ni eih" and "ya3ny eh" end up close
- Arabic normalisation - diacritics stripped, أ إ آ unified to ا, ى -> ي, ة -> ه, punctuation removed, so "يعني ايه" matches "يعني إيه؟"
- Arabic detection - if more than 40% of the characters in your answer are arabic script it's compared with the arabic variants instead of the transliterations
- Groups - cards are tagged [kind, group], e.g. ["verbs", "go"] or ["essentials", "greetings"]. A category counts as a verb category if its cards are tagged "verbs" first, and either way the second tag is what the category screen groups by. Verb groups are named after the "he" card
- Pronoun variants - scripts/add-pronoun-variants.mjs adds "howa beyerooh" as an accepted answer next to "beyerooh" for every conjugation, so you can answer with or without the pronoun
- Mastery is separate from sm-2 - sm-2 handles the interval and ease, mastery is just a streak of different-day correct answers, so one can't mess up the other
- Card loading - bundled json -> local storage cache -> supabase. The cache key is versioned (ea_cards_v2) so I can force a refresh when the card format changes
- One audio element - ios only lets a page play sound after a tap, so the app reuses the element unlocked by the first tap and autoplay on later cards works
- Iphone details - inputs are 16px so safari doesn't zoom in when you tap them, and autocorrect and autocapitalise are off on the transliteration box

#### Project structure

- src/App.tsx - screen state and the card fetch on load
- src/components/HomeScreen.tsx - categories, mastery bar and recent words
- src/components/CategoryScreen.tsx - mode picker and the verb or topic groups
- src/components/StudyScreen.tsx - the three modes and the answer checking
- src/components/SummaryScreen.tsx - end of session score, try again, review wrong
- src/components/AdminScreen.tsx - add a card with recorded or generated audio
- src/lib/matching.ts and src/lib/normalise.ts - answer matching
- src/lib/srs.ts - sm-2, mastery streak and dismissing
- src/lib/progress.ts - local storage read and write
- src/lib/categories.ts - categories, shuffling, verb and topic grouping
- src/lib/cards.ts - bundled, cached and supabase card loading
- src/lib/audio.ts - the shared audio player
- src/data/cards.json - the deck
- public/audio/ - the generated mp3s
- netlify/functions/tts.js - elevenlabs proxy used by the admin screen
- netlify/functions/whisper.js - openai whisper proxy (not wired into the ui yet, see limitations)
- scripts/generate-audio.js - generates the mp3s for every card
- scripts/seed-supabase.mjs - turns cards.json into supabase/seed.sql
- scripts/add-pronoun-variants.mjs - adds pronoun-prefixed accepted answers to verb cards
- scripts/gen-icons.mjs - draws the app icons
- supabase/seed.sql - creates the cards table and inserts the deck (generated, don't edit by hand)
- test/ - vitest tests for the matching, normalisation, srs and grouping code
- .github/workflows/ci.yml - runs the typecheck, tests and build on github on every push

#### Setup

You'll need:

- Node.js 18 or later
- A [supabase](https://supabase.com/) project (the free plan is fine) - optional, the app runs on the bundled cards without it
- An [elevenlabs](https://elevenlabs.io/) account and an egyptian arabic voice id - only if you want to regenerate the audio or use the generate button on the admin screen
- A [netlify](https://www.netlify.com/) account to deploy

```bash
git clone https://github.com/rachelw320/language_learning_app.git
cd language_learning_app
npm install
```

#### Environment variables

- VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY - read by the front end. If they're missing the app falls back to the bundled cards instead of crashing
- ELEVENLABS_API_KEY and ELEVENLABS_ARABIC_VOICE_ID - used by scripts/generate-audio.js locally and by netlify/functions/tts.js, so set them in the netlify dashboard too
- OPENAI_API_KEY - only for the whisper function, which the app doesn't call yet

Put them in a .env file locally - it's git-ignored and only .env.example with placeholder values is committed.

#### Running locally

```bash
cp .env.example .env   # add your real values - .env is git-ignored
npm run dev
```

That runs the app on vite's dev server. The netlify functions (the generate button on the admin screen) only run under netlify's own dev server:

```bash
npx netlify dev
```

To run the checks (github actions runs these on every push too):

```bash
npm run typecheck
npm test
npm run format:check   # or npm run format to fix it
```

To regenerate every card's audio after editing cards.json:

```bash
npm run generate-audio
```

And to check it builds (this is what netlify runs):

```bash
npm run build   # tsc, then vite build into dist/
```

#### Deploying

Netlify: connect the repo, and netlify.toml already sets the build command (npm run build), the publish directory (dist) and the functions directory. Add the environment variables in site settings. Audio files get a one year immutable cache header.

Supabase: run supabase/seed.sql in the sql editor to create the cards table and insert the deck (regenerate it with npm run seed after changing cards.json). The seed only adds a public read policy, so for the admin screen to work you also need an insert policy on cards and a public storage bucket called audio that allows uploads.

#### Adding it to your phone

Open the site in safari, share -> add to home screen. It opens full screen without the browser bar thanks to the manifest and the apple meta tags in index.html. There's no service worker, so it needs a connection.

#### Limitations

- Progress lives in local storage, so it's per device and clearing safari's website data wipes it. There are no accounts (I removed login to keep it simple)
- The sm-2 due dates are recorded but nothing uses them yet - you pick a category or group to study, the app doesn't pick cards by what's due
- The 72% threshold is forgiving on purpose, which means very short words can pass with a wrong letter. The transliteration normaliser also drops 7, 5 and 9 (ح, خ, غ), so those letters don't count in the comparison
- The audio is ai generated, not a native speaker. It's good for the dialect but it isn't perfect
- Speaking practice is half built - the whisper function exists but nothing in the app calls it
- The deck is uneven, core verbs is two thirds of it
- The admin screen has no login (see below)

#### Security considerations

- The elevenlabs and openai keys are only ever used inside the netlify functions, the browser never sees them
- The supabase anon key is public by design and the cards table is publicly readable. With an insert policy for the admin screen, anyone with the url can add cards and upload audio. It's a personal app, but it's the first thing I'd change
- .env is git-ignored and only .env.example with placeholders is committed
- scripts/generate-audio.js turns off certificate checking (NODE_TLS_REJECT_UNAUTHORIZED=0) so it works on networks that swap in their own certificates, like university wifi. It only ever runs on my laptop, the deployed function doesn't do this

#### Possible future improvements

- Use the sm-2 due dates to build a daily review session across categories
- Finish speaking practice with whisper
- Optional accounts so progress syncs between devices
- A service worker so it works offline
- Lock the admin screen behind a password or a supabase login
- Keep 7, 5 and 9 in the transliteration matching
- Show the notes field on cards, it exists but is empty at the moment
- A "next group" button on the summary screen

#### License

[Mit](LICENSE)
