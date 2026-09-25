### Egyptian Arabic flashcard app

A react and typescript pwa for learning egyptian arabic, with typed answers, fuzzy matching for transliteration, spaced repetition and audio for every card. The backend is a lambda api on aws with aurora postgres and s3, all defined in cdk

#### Overview

It's a small web app I use on my phone. The home screen lists the categories and a mastery bar (how many of the 369 cards I've mastered so far), you pick a category and then one of three modes:

- English -> arabic: the english plays and is shown, you type the transliteration (or the arabic itself if you have an arabic keyboard)
- Arabic -> english: the arabic plays and is shown with its transliteration, you type the meaning
- Browse: search and scroll through every card in the category and tap to hear it

A session is either the whole category shuffled ("mix all") or one group from it - verb categories are grouped by verb so you get every conjugation of "go" together, and the others are grouped by topic. Progress is saved on the device, there are no accounts.

The cards come from a postgres database through a small api, but the deck is also bundled into the app, so it works even when the api is asleep or you're offline.

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

Every card has an arabic and an english mp3 under public/audio, generated once with elevenlabs (the eleven_v3 model with an egyptian arabic voice) by scripts/generate-audio.js and committed to the repo, so netlify just serves them as static files with a one year cache header. Audio for cards added later lives in s3 instead (see the admin screen). The right side plays automatically when a card comes up and the speaker button replays it.

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

The same cards are in the postgres database. The app starts with the bundled json (or the last copy it cached), then fetches from the api and swaps that in if it works, so I can add cards without redeploying.

##### Admin screen

The + on the home screen opens a form to add a card. It asks for the admin password, then a category, english, arabic and transliteration, and for each language you can either hold to record the audio yourself or generate it with elevenlabs. Recordings upload straight to s3 with a presigned url from the api, the card goes in through the api, and the app reloads the deck.

#### Architecture

```
browser (netlify) --> api gateway --> lambda (hono) --> aurora serverless v2 postgres (over the rds data api)
                                                   \--> s3 (presigned uploads) --> cloudfront (audio urls)
```

Everything on the right of the browser is one cdk stack (infra/lib/stack.ts). The lambda isn't in the vpc - it talks to aurora over the rds data api, which is plain https with iam auth, so there's no connection pooling to think about and no nat gateway to pay for. The database scales down to zero when nobody's studying and wakes up on the next query.

##### Loading cards

1. The app renders straight away with the cached or bundled cards.
2. It calls GET /cards.
3. The lambda queries aurora through the data api. If the database was paused this first query takes about 15 seconds while it wakes up.
4. The app swaps in the live cards and caches them in local storage for next time.

##### Adding a card

1. The admin screen sends the admin password in an x-admin-key header on every write.
2. For each recording it asks POST /audio/upload-url, gets back a presigned s3 url that's valid for 5 minutes, and PUTs the file straight to the bucket.
3. It then sends POST /cards. The lambda validates the body with zod and says exactly which fields are wrong if it isn't happy.
4. The lambda inserts the row (working out the position from the last card) and returns the finished card.
5. The app reloads the deck from the api.

#### Tech stack

- React 18 and typescript, built with vite, hosted on netlify
- Tailwind css
- Hono on aws lambda (node 22, arm64) behind an api gateway http api
- Aurora serverless v2 postgres, accessed through the rds data api, with drizzle orm and generated migrations
- S3 and cloudfront for uploaded audio
- Aws cdk for all of the infrastructure
- Elevenlabs for the audio
- Vitest for the tests, prettier for formatting, github actions to run the checks

#### Key implementation details

- Fuzzy matching - levenshtein distance turned into a 0 to 1 similarity, best score across all the accepted variants, pass threshold 0.72. In src/lib/matching.ts
- Transliteration normalisation - lowercased, apostrophes removed, ph -> f, ck -> k, oo -> u, ei -> e, ai -> a, then everything except letters, spaces, 2 and 3 is dropped (2 and 3 are the chat arabic letters for ء and ع). So "ya3ni eih" and "ya3ny eh" end up close
- Arabic normalisation - diacritics stripped, أ إ آ unified to ا, ى -> ي, ة -> ه, punctuation removed, so "يعني ايه" matches "يعني إيه؟"
- Arabic detection - if more than 40% of the characters in your answer are arabic script it's compared with the arabic variants instead of the transliterations
- Groups - cards are tagged [kind, group], e.g. ["verbs", "go"] or ["essentials", "greetings"]. A category counts as a verb category if its cards are tagged "verbs" first, and either way the second tag is what the category screen groups by. Verb groups are named after the "he" card
- Mastery is separate from sm-2 - sm-2 handles the interval and ease, mastery is just a streak of different-day correct answers, so one can't mess up the other
- Card loading - bundled json -> local storage cache -> api. The cache key is versioned (ea_cards_v2) so I can force a refresh when the card format changes
- Aurora scales to zero - minimum capacity is 0 acu, so it pauses after a few idle minutes and costs nothing until the next query. The app starting on its bundled cards is what hides the wake up time
- Data api instead of a vpc lambda - a lambda inside the vpc would need a nat gateway to reach elevenlabs, and that's the one thing in this stack that would cost real money every month
- Jsonb for the list fields - the data api is awkward with postgres arrays, so accepted, arabic variants, tags and audio are jsonb columns. "order" is a reserved word so the column is called "position"
- Presigned uploads - the browser uploads audio straight to s3 rather than pushing the bytes through the lambda. The url only allows the three content types the app produces and dies after 5 minutes
- One shared password - the write routes compare the x-admin-key header with a constant time compare. It's a password not accounts, which is fine for one person's app
- Testable api - createApp takes the database and the aws bits as arguments, so the tests run the real routes against fakes
- One audio element - ios only lets a page play sound after a tap, so the app reuses the element unlocked by the first tap and autoplay on later cards works
- Iphone details - inputs are 16px so safari doesn't zoom in when you tap them, and autocorrect and autocapitalise are off on the transliteration box

#### Project structure

- src/App.tsx - screen state and the card fetch on load
- src/components/ - home, category, study, summary and admin screens
- src/lib/api.ts - the calls to the api
- src/lib/cards.ts - bundled, cached and live card loading
- src/lib/matching.ts and src/lib/normalise.ts - answer matching
- src/lib/srs.ts - sm-2, mastery streak and dismissing
- src/lib/progress.ts - local storage read and write
- src/lib/categories.ts - categories, shuffling, verb and topic grouping
- src/lib/audio.ts - the shared audio player
- src/data/cards.json - the deck
- public/audio/ - the generated mp3s
- shared/ - the card type and zod schemas that the app and the api both use
- api/src/index.ts - the lambda entry point, wires up aurora, s3 and elevenlabs
- api/src/app.ts - the hono routes
- api/src/cards.ts - reading and writing cards with drizzle
- api/src/schema.ts - the drizzle table definition
- api/src/db.ts - the drizzle client over the data api
- api/src/elevenlabs.ts - text to speech
- infra/ - the cdk app and stack
- db/migrations/ - sql generated from the schema by drizzle-kit
- scripts/db-migrate.ts and scripts/db-seed.ts - apply migrations and load the deck, over the data api
- scripts/generate-audio.js - generates the mp3s for every card
- scripts/add-pronoun-variants.mjs - adds pronoun-prefixed accepted answers to verb cards
- scripts/gen-icons.mjs - draws the app icons
- test/ - vitest tests for the matching, normalisation, srs, grouping and api code
- .github/workflows/ci.yml - runs the typecheck, tests, cdk synth and build on github on every push

#### Setup

You'll need:

- Node.js 22 (the lambda runs on 22 as well)
- An [aws](https://aws.amazon.com/) account with the aws cli installed and `aws configure` done
- An [elevenlabs](https://elevenlabs.io/) account and an egyptian arabic voice id - only if you want to regenerate the audio or use the generate button on the admin screen
- A [netlify](https://www.netlify.com/) account for the site

```bash
git clone https://github.com/rachelw320/language_learning_app.git
cd language_learning_app
npm install
cp .env.example .env   # fill in the values, .env is git-ignored
```

#### Environment variables

- VITE_API_URL - the api, printed as ApiUrl when you deploy. Read by the app in the browser, so set it in the netlify dashboard too. Without it the app just uses the bundled cards
- APP_ORIGIN - where the site is served from, for cors on the api and the bucket
- ADMIN_PASSWORD - what the admin screen asks for
- ELEVENLABS_API_KEY and ELEVENLABS_ARABIC_VOICE_ID - used by scripts/generate-audio.js locally and by the tts route on the lambda

The last three are read by the cdk app at deploy time and put on the lambda as environment variables. The aws credentials themselves come from `aws configure`.

#### Running locally

```bash
npm run dev
```

That runs the app on vite's dev server, against the deployed api if VITE_API_URL is set and the bundled cards if not.

To run the checks (github actions runs these on every push too):

```bash
npm run typecheck
npm test
npm run format:check   # or npm run format to fix it
npm run infra:synth    # compiles the cdk stack and bundles the lambda, no aws credentials needed
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

The backend, from a machine with aws credentials:

```bash
npx cdk bootstrap      # once per aws account and region
npm run infra:deploy   # creates everything and writes the outputs to cdk-outputs.json
npm run db:migrate     # creates the cards table
npm run db:seed        # loads src/data/cards.json into it
```

Then put the ApiUrl output in VITE_API_URL on netlify and redeploy the site. Netlify.toml already sets the build command (npm run build) and the publish directory (dist). Audio files get a one year immutable cache header.

Changing the database: edit api/src/schema.ts, run `npm run db:generate` to get a migration file, and `npm run db:migrate` to apply it.

Tearing it all down is `npm run infra:destroy`. It keeps a final snapshot of the database and leaves the audio bucket alone.

What it costs: with nobody using it, under a pound a month - aurora storage, the secrets manager secret for the database password, and nothing for the lambda, api gateway, cloudfront or s3 at this size. While someone's actually studying, aurora bills per second at half an acu, which is pennies for a few minutes.

#### Adding it to your phone

Open the site in safari, share -> add to home screen. It opens full screen without the browser bar thanks to the manifest and the apple meta tags in index.html. There's no service worker, so it needs a connection.

#### Limitations

- Progress lives in local storage, so it's per device and clearing safari's website data wipes it. There are no accounts (I removed login to keep it simple)
- The sm-2 due dates are recorded but nothing uses them yet - you pick a category or group to study, the app doesn't pick cards by what's due
- The first request after the database has paused takes about 15 seconds. The app hides this by starting on the bundled cards, but the admin screen will feel slow on the first save of the day
- The 72% threshold is forgiving on purpose, which means very short words can pass with a wrong letter. The transliteration normaliser also drops 7, 5 and 9 (ح, خ, غ), so those letters don't count in the comparison
- The audio is ai generated, not a native speaker. It's good for the dialect but it isn't perfect
- The deck is uneven, core verbs is two thirds of it
- The admin screen is a shared password, not proper accounts

#### Security considerations

- The elevenlabs key and the admin password only exist on the lambda, as environment variables (encrypted at rest). Secrets manager would be the next step
- The database is in isolated subnets with no route to the internet. The only way in is the data api, which needs iam permissions the lambda has and nothing else does. Its password is generated and kept in secrets manager
- The audio bucket blocks all public access. Cloudfront is the only thing allowed to read it, and uploads need a presigned url from the api, which only hands them out with the admin password
- Cors on the api and the bucket is locked to the site's origin (and localhost)
- .env, cdk.out and cdk-outputs.json are git-ignored, only .env.example with placeholders is committed
- scripts/generate-audio.js turns off certificate checking (NODE_TLS_REJECT_UNAUTHORIZED=0) so it works on networks that swap in their own certificates, like university wifi. It only ever runs on my laptop

#### Possible future improvements

- Move the elevenlabs key and admin password into secrets manager
- Real login (cognito) instead of a shared password
- Use the sm-2 due dates to build a daily review session across categories
- Accounts so progress syncs between devices - a progress table is easy now there's a database
- Speaking practice with whisper as another route on the lambda
- A service worker so it works offline
- Keep 7, 5 and 9 in the transliteration matching
- Show the notes field on cards, it exists but is empty at the moment
- A "next group" button on the summary screen

#### License

[Mit](LICENSE)
