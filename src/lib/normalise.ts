/** Strips diacritics and unifies the letters that get spelt more than one way, so "يعني ايه" matches "يعني إيه؟" */
export function normaliseArabic(text: string): string {
	return text
		.replace(/[ً-ٰٟ]/g, '') // tashkeel - fatha, shadda, sukun and friends
		.replace(/[أإآ]/g, 'ا') // all the alef forms
		.replace(/ى/g, 'ي') // alef maqsura -> ya
		.replace(/ة/g, 'ه') // ta marbuta -> ha
		.replace(/[‌‍]/g, '') // zero width joiners that sneak in from some keyboards
		.replace(/[؟!،.?,]/g, '')
		.replace(/\s+/g, ' ')
		.trim();
}

/** Lowercases and smooths out the different spellings people use for the same sound, so "ya3ni eih" and "ya3ny eh" end up close */
export function normaliseTransliteration(text: string): string {
	return (
		text
			.toLowerCase()
			.replace(/['’`ʾʿ]/g, '')
			.replace(/ph/g, 'f')
			.replace(/ck/g, 'k')
			.replace(/oo/g, 'u')
			.replace(/ei/g, 'e')
			.replace(/ai/g, 'a')
			// Only letters, spaces, and the 2 and 3 people use for ء and ع
			.replace(/[^a-z23 ]/g, '')
			.replace(/\s+/g, ' ')
			.trim()
	);
}

/** Takes the bracketed notes off an english prompt, e.g. "you go (to a man)" -> "you go" */
export function stripQualifiers(text: string): string {
	return text
		.replace(/\([^)]*\)/g, '')
		.replace(/\s+/g, ' ')
		.trim();
}

/** Lowercases an english answer and drops apostrophes and bracketed notes, so "I'm fine" matches "im fine (f)" */
export function normaliseEnglish(text: string): string {
	return stripQualifiers(text).toLowerCase().replace(/['’`]/g, '').trim();
}
