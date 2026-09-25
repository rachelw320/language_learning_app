/**
 * Adds the pronoun-prefixed spelling to the accepted answers of every verb card, so "howa beyerooh" counts as well as "beyerooh".
 * The pronoun comes from the english ("He goes" -> howa). Safe to run again, it skips anything already there.
 *
 * Usage: node scripts/add-pronoun-variants.mjs
 */

import { readFileSync, writeFileSync } from 'fs';
import { dirname, join } from 'path';
import { fileURLToPath } from 'url';

const CARDS_PATH = join(dirname(fileURLToPath(import.meta.url)), '../src/data/cards.json');

// Checked in order, so the "to a man" / "to a woman" ones have to come before anything that would match plain "You"
const PRONOUNS = [
	[/^I /i, 'ana'],
	[/^You .+to a man/i, 'enta'],
	[/^You .+to a woman/i, 'enti'],
	[/^He /i, 'howa'],
	[/^She /i, 'heya'],
	[/^We /i, 'ehna'],
	[/^They /i, 'homma'],
];

function pronounFor(english) {
	for (const [pattern, pronoun] of PRONOUNS) {
		if (pattern.test(english)) {
			return pronoun;
		}
	}
	return null;
}

const cards = JSON.parse(readFileSync(CARDS_PATH, 'utf8'));
let updated = 0;

const result = cards.map((card) => {
	if (card.tags[0] !== 'verbs') {
		return card;
	}
	const pronoun = pronounFor(card.english);
	if (!pronoun) {
		return card;
	}
	const withPronoun = `${pronoun} ${card.transliteration}`;
	if (card.accepted.includes(withPronoun)) {
		return card;
	}
	updated++;
	return { ...card, accepted: [...card.accepted, withPronoun] };
});

// Keep the one card per line layout so diffs stay readable
writeFileSync(CARDS_PATH, '[\n' + result.map((card) => '  ' + JSON.stringify(card)).join(',\n') + '\n]\n');
console.log(`Added pronoun variants to ${updated} verb cards`);
