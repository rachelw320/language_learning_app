// Strip Arabic diacritics (tashkeel), normalize alef/ya/ta forms
export function normalizeArabic(text: string): string {
  return text
    .replace(/[ً-ٰٟ]/g, '') // remove diacritics (harakat, shadda, etc.)
    .replace(/[أإآ]/g, 'ا')                  // unify alef forms
    .replace(/ى/g, 'ي')                      // alef maqsura → ya
    .replace(/ة/g, 'ه')                      // ta marbuta → ha
    .replace(/‌|‍/g, '')            // remove zero-width characters
    .replace(/[؟!،.]/g, '')                   // strip Arabic punctuation
    .replace(/[?!,.]/g, '')                    // strip Latin punctuation
    .replace(/\s+/g, ' ')
    .trim()
}

// Normalise transliteration for flexible matching
export function normalizeTranslit(text: string): string {
  return text
    .toLowerCase()
    .replace(/['’`ʾʿ]/g, '')             // remove apostrophes
    .replace(/ph/g, 'f')                       // ph → f
    .replace(/ck/g, 'k')
    .replace(/oo/g, 'u')                       // oo → u (optional: keeps both by not replacing)
    .replace(/ei/g, 'e')                       // ei → e
    .replace(/ai/g, 'a')                       // ai → a
    .replace(/[^a-z023 ]/g, '')                // only keep letters, 2, 3, spaces
    .replace(/\s+/g, ' ')
    .trim()
}
