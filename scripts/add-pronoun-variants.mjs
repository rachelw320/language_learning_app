/**
 * Adds pronoun-prefixed accepted variants to all verb conjugation cards.
 * e.g. "He goes" gets "howa beyerooh" added to accepted[]
 * alongside the bare "beyerooh" that already exists.
 *
 * Usage: node scripts/add-pronoun-variants.mjs
 */

import { readFileSync, writeFileSync } from 'fs'
import { fileURLToPath } from 'url'
import { dirname, join } from 'path'

const __dirname = dirname(fileURLToPath(import.meta.url))
const cardsPath = join(__dirname, '../src/data/cards.json')
const cards = JSON.parse(readFileSync(cardsPath, 'utf8'))

function getPronoun(english) {
  if (/^I .+\(f\)/i.test(english) || /^I .+\(m\)/i.test(english)) return 'ana'
  if (/^I /i.test(english)) return 'ana'
  if (/^You .+to a man/i.test(english)) return 'enta'
  if (/^You .+to a woman/i.test(english)) return 'enti'
  if (/^He /i.test(english)) return 'howa'
  if (/^She /i.test(english)) return 'heya'
  if (/^We /i.test(english)) return 'ehna'
  if (/^They /i.test(english)) return 'homma'
  return null
}

let updated = 0
const result = cards.map(card => {
  if (card.tags[0] !== 'verbs') return card

  const pronoun = getPronoun(card.english)
  if (!pronoun) return card

  const withPronoun = `${pronoun} ${card.transliteration}`
  if (card.accepted.includes(withPronoun)) return card

  updated++
  return { ...card, accepted: [...card.accepted, withPronoun] }
})

// Write back preserving compact single-line-per-card format
const output = '[\n' + result.map(c => '  ' + JSON.stringify(c)).join(',\n') + '\n]\n'
writeFileSync(cardsPath, output)
console.log(`✓ Added pronoun variants to ${updated} verb cards`)
