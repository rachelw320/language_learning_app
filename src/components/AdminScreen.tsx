import { useRef, useState } from 'react';
import type { AudioLanguage } from '../../shared/validation';
import { createCard, generateSpeech, hasApi, uploadAudio } from '../lib/api';
import { getCategories } from '../lib/categories';
import { stripQualifiers } from '../lib/normalise';
import type { Card } from '../types';

interface Props {
	cards: Card[];
	onBack: () => void;
	// Called after a card is saved so the app can reload the deck from the api
	onSaved: () => void;
}

const LANGUAGES: AudioLanguage[] = ['ar', 'en'];

// The admin password only lives for the tab, so it's not sitting in local storage forever
const ADMIN_KEY_STORAGE = 'ea_admin_key';

// How long "Saved!" stays on the button
const SAVED_MESSAGE_MS = 2000;

const inputClass =
	'w-full bg-surface border border-border rounded-2xl px-4 py-3 text-textPrimary placeholder-textSecondary outline-none focus:border-primary';

function rememberedAdminKey(): string {
	try {
		return sessionStorage.getItem(ADMIN_KEY_STORAGE) ?? '';
	} catch {
		return '';
	}
}

export default function AdminScreen({ cards, onBack, onSaved }: Props) {
	const [adminKey, setAdminKey] = useState(rememberedAdminKey);
	const [category, setCategory] = useState('');
	const [english, setEnglish] = useState('');
	const [arabic, setArabic] = useState('');
	const [transliteration, setTransliteration] = useState('');
	const [arabicAudio, setArabicAudio] = useState<Blob | null>(null);
	const [englishAudio, setEnglishAudio] = useState<Blob | null>(null);
	const [recording, setRecording] = useState<AudioLanguage | null>(null);
	const [generating, setGenerating] = useState<AudioLanguage | null>(null);
	const [saving, setSaving] = useState(false);
	const [saved, setSaved] = useState(false);
	const [error, setError] = useState('');

	const recorderRef = useRef<MediaRecorder | null>(null);
	const chunksRef = useRef<Blob[]>([]);

	const categories = getCategories(cards);

	const audioFor = (lang: AudioLanguage) => (lang === 'ar' ? arabicAudio : englishAudio);
	const setAudioFor = (lang: AudioLanguage, blob: Blob | null) => (lang === 'ar' ? setArabicAudio(blob) : setEnglishAudio(blob));
	const textFor = (lang: AudioLanguage) => (lang === 'ar' ? arabic.trim() : english.trim());

	const updateAdminKey = (value: string) => {
		setAdminKey(value);
		try {
			sessionStorage.setItem(ADMIN_KEY_STORAGE, value);
		} catch {
			// Private browsing can block this, you'll just have to type it again next time
		}
	};

	// Hold to record - this runs on pointer down and stopRecording on pointer up
	const startRecording = async (lang: AudioLanguage) => {
		setError('');
		try {
			const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
			// Safari can't record webm, so it gets mp4
			const mimeType = MediaRecorder.isTypeSupported('audio/webm') ? 'audio/webm' : 'audio/mp4';
			const recorder = new MediaRecorder(stream, { mimeType });
			chunksRef.current = [];
			recorder.ondataavailable = (event) => {
				if (event.data.size > 0) {
					chunksRef.current.push(event.data);
				}
			};
			recorder.onstop = () => {
				setAudioFor(lang, new Blob(chunksRef.current, { type: mimeType }));
				stream.getTracks().forEach((track) => track.stop());
			};
			recorder.start();
			recorderRef.current = recorder;
			setRecording(lang);
		} catch {
			setError("Couldn't get permission to use the microphone :(");
		}
	};

	const stopRecording = () => {
		recorderRef.current?.stop();
		setRecording(null);
	};

	// The bracketed notes on english cards ("(to a man)") aren't read out
	const generate = async (lang: AudioLanguage) => {
		const text = lang === 'ar' ? arabic.trim() : stripQualifiers(english);
		if (!text) {
			return;
		}
		setGenerating(lang);
		setError('');
		try {
			setAudioFor(lang, await generateSpeech(text, lang, adminKey));
		} catch (err) {
			setError(err instanceof Error ? err.message : "Couldn't generate the audio :(");
		} finally {
			setGenerating(null);
		}
	};

	const playBlob = (blob: Blob) => {
		const url = URL.createObjectURL(blob);
		const player = new Audio(url);
		player.onended = () => URL.revokeObjectURL(url);
		player.play();
	};

	const handleSave = async () => {
		if (!category.trim() || !english.trim() || !arabic.trim() || !transliteration.trim()) {
			setError('Category, English, Arabic and transliteration are all needed :(');
			return;
		}

		setSaving(true);
		setError('');
		try {
			const audio = {
				ar: arabicAudio ? await uploadAudio(arabicAudio, 'ar', adminKey) : '',
				en: englishAudio ? await uploadAudio(englishAudio, 'en', adminKey) : '',
			};
			await createCard(
				{ category: category.trim(), english: english.trim(), arabic: arabic.trim(), transliteration: transliteration.trim(), audio },
				adminKey,
			);

			// Keep the category and password, you're probably adding a few in a row
			setEnglish('');
			setArabic('');
			setTransliteration('');
			setArabicAudio(null);
			setEnglishAudio(null);
			setSaved(true);
			setTimeout(() => setSaved(false), SAVED_MESSAGE_MS);
			onSaved();
		} catch (err) {
			setError(err instanceof Error ? err.message : "Couldn't save the card :(");
		} finally {
			setSaving(false);
		}
	};

	const canSave = Boolean(adminKey && category.trim() && english.trim() && arabic.trim() && transliteration.trim()) && !saving;

	return (
		<div className="flex flex-col h-full safe-top safe-bottom">
			<div className="flex items-center justify-between px-5 py-4 border-b border-border flex-shrink-0">
				<button onClick={onBack} className="text-primary pressable text-sm font-medium">
					← Back
				</button>
				<span className="text-textSecondary text-sm">Add a card</span>
				<div className="w-12" />
			</div>

			<div className="flex-1 px-5 py-6 space-y-3 overflow-y-auto">
				{!hasApi && (
					<p className="text-danger text-sm text-center">There's no api set up (VITE_API_URL), so cards can't be saved from here</p>
				)}

				<input
					type="password"
					value={adminKey}
					onChange={(e) => updateAdminKey(e.target.value)}
					placeholder="Admin password"
					autoComplete="current-password"
					className={inputClass}
				/>
				<input
					value={category}
					onChange={(e) => setCategory(e.target.value)}
					placeholder="Category"
					list="categories"
					autoComplete="off"
					className={inputClass}
				/>
				<datalist id="categories">
					{categories.map((name) => (
						<option key={name} value={name} />
					))}
				</datalist>
				<input value={english} onChange={(e) => setEnglish(e.target.value)} placeholder="English" className={inputClass} />
				<input
					value={arabic}
					onChange={(e) => setArabic(e.target.value)}
					placeholder="عربي"
					dir="rtl"
					lang="ar"
					className={`${inputClass} text-right`}
				/>
				<input
					value={transliteration}
					onChange={(e) => setTransliteration(e.target.value)}
					placeholder="Transliteration"
					autoCorrect="off"
					autoCapitalize="none"
					autoComplete="off"
					spellCheck={false}
					className={inputClass}
				/>

				<div className="pt-2">
					<p className="text-textSecondary text-xs uppercase tracking-wide mb-3">Audio</p>
					{LANGUAGES.map((lang) => {
						const blob = audioFor(lang);
						const isRecording = recording === lang;
						return (
							<div key={lang} className="flex items-center gap-2 mb-2">
								<span className="text-textSecondary text-sm font-medium w-7 uppercase">{lang}</span>
								<button
									onPointerDown={() => {
										if (!isRecording) {
											startRecording(lang);
										}
									}}
									onPointerUp={isRecording ? stopRecording : undefined}
									onPointerLeave={isRecording ? stopRecording : undefined}
									className={`flex-1 py-2.5 rounded-2xl text-sm font-medium pressable border transition-colors ${
										isRecording ? 'bg-danger border-danger text-white' : 'bg-surface border-border text-textPrimary'
									}`}
								>
									{isRecording ? 'Release to stop' : 'Hold to record'}
								</button>
								<button
									onClick={() => generate(lang)}
									disabled={generating !== null || !adminKey || !textFor(lang)}
									className="flex-1 py-2.5 rounded-2xl text-sm font-medium pressable bg-surface border border-border text-textPrimary disabled:opacity-40"
								>
									{generating === lang ? 'Generating…' : 'Generate'}
								</button>
								{blob && (
									<button
										onClick={() => playBlob(blob)}
										className="w-10 h-10 rounded-full bg-primary flex items-center justify-center pressable flex-shrink-0 text-white text-sm"
										aria-label="Play"
									>
										▶
									</button>
								)}
							</div>
						);
					})}
				</div>

				{error && <p className="text-danger text-sm text-center">{error}</p>}

				<button
					onClick={handleSave}
					disabled={!canSave}
					className={`w-full py-4 rounded-2xl font-medium pressable transition-colors ${
						saved ? 'bg-success text-white' : 'bg-primary text-white disabled:opacity-40'
					}`}
				>
					{saved ? 'Saved!' : saving ? 'Saving…' : 'Save card'}
				</button>
			</div>
		</div>
	);
}
