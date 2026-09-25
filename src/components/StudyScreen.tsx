import { useEffect, useRef, useState } from 'react';
import { playAudio } from '../lib/audio';
import { checkAnswer, checkEnglish } from '../lib/matching';
import { STUDY_MODE_LABELS } from '../lib/modes';
import { loadProgress, saveProgress, type ProgressMap } from '../lib/progress';
import { calculateNextReview, dismissCard, newCardProgress, updateMastery } from '../lib/srs';
import type { Card, CardProgress, StudyMode } from '../types';

interface Props {
	mode: StudyMode;
	cards: Card[];
	onBack: () => void;
	onComplete: (correct: Card[], incorrect: Card[]) => void;
}

type AnswerState = 'idle' | 'correct' | 'incorrect';

// How long the green "correct" panel shows before the next card comes up
const CORRECT_PAUSE_MS = 650;

const inputClass =
	'w-full bg-surfaceHigh border border-transparent focus:border-primary rounded-2xl px-4 py-4 text-white placeholder-textSecondary outline-none transition-colors';

interface HeaderProps {
	title: string;
	detail: string;
	onBack: () => void;
}

function Header({ title, detail, onBack }: HeaderProps) {
	return (
		<div className="flex items-center justify-between px-5 pt-4 pb-3 border-b border-border flex-shrink-0">
			<button onClick={onBack} className="text-primary pressable text-sm font-medium">
				← Back
			</button>
			<span className="text-textSecondary text-sm font-medium">{title}</span>
			<span className="text-textSecondary text-xs">{detail}</span>
		</div>
	);
}

interface FeedbackProps {
	card: Card;
	answer: string;
	answerState: AnswerState;
	matchScore: number;
	// English -> arabic reveals the arabic, the other way round reveals the english
	revealArabic: boolean;
	isMastered: boolean;
	onDismiss: () => void;
}

function FeedbackPanel({ card, answer, answerState, matchScore, revealArabic, isMastered, onDismiss }: FeedbackProps) {
	const isCorrect = answerState === 'correct';
	return (
		<div
			className={`fade-in rounded-2xl px-5 py-4 border ${isCorrect ? 'border-success/40 bg-success/10' : 'border-danger/40 bg-danger/10'}`}
		>
			<div className="flex items-baseline gap-2 mb-2">
				<span className={`font-bold text-base ${isCorrect ? 'text-success' : 'text-danger'}`}>{isCorrect ? 'Correct' : 'Not quite'}</span>
				{!isCorrect && <span className="text-textSecondary text-xs">{Math.round(matchScore * 100)}% match</span>}
				{isCorrect && isMastered && <span className="text-yellow-400 text-xs font-semibold">Mastered</span>}
			</div>

			{revealArabic ? (
				<>
					<p className="arabic-text text-white text-3xl leading-relaxed">{card.arabic}</p>
					<p className="text-primary text-base mt-1">{card.transliteration}</p>
				</>
			) : (
				<p className="text-white text-xl font-semibold">{card.english}</p>
			)}

			{!isCorrect && (
				<p className="text-textSecondary text-sm mt-2">
					You wrote: <span className="text-white">{answer}</span>
				</p>
			)}

			{isCorrect && isMastered && (
				<button onClick={onDismiss} className="mt-3 text-xs text-textSecondary underline pressable">
					Mastered · don't show again for a week
				</button>
			)}
		</div>
	);
}

export default function StudyScreen({ mode, cards, onBack, onComplete }: Props) {
	const [cardIndex, setCardIndex] = useState(0);
	const [progress, setProgress] = useState<ProgressMap>(loadProgress);
	const [answer, setAnswer] = useState('');
	const [answerState, setAnswerState] = useState<AnswerState>('idle');
	const [matchScore, setMatchScore] = useState(0);
	const [searchQuery, setSearchQuery] = useState('');
	const inputRef = useRef<HTMLInputElement>(null);
	// A ref rather than state because nothing renders these, they're only handed over when the session ends
	const results = useRef<{ correct: Card[]; incorrect: Card[] }>({ correct: [], incorrect: [] });

	const card = cards[cardIndex];
	const isEnglishToArabic = mode === 'english-to-arabic';

	// Play the prompt side of the card as soon as it comes up
	useEffect(() => {
		if (mode === 'browse' || !card) {
			return;
		}
		playAudio(isEnglishToArabic ? card.audio.en : card.audio.ar).catch(() => {});
	}, [cardIndex, card, mode, isEnglishToArabic]);

	// Put the cursor in the box for each new card. The short delay lets the fade-in finish first
	useEffect(() => {
		if (mode === 'browse' || answerState !== 'idle') {
			return;
		}
		const timer = setTimeout(() => inputRef.current?.focus(), 120);
		return () => clearTimeout(timer);
	}, [cardIndex, mode, answerState]);

	if (!card) {
		return (
			<div className="flex flex-col h-full safe-top">
				<Header title={STUDY_MODE_LABELS[mode]} detail="" onBack={onBack} />
				<p className="text-textSecondary text-sm text-center px-5 py-10">Nothing to study here yet</p>
			</div>
		);
	}

	const updateProgress = (update: (current: CardProgress) => CardProgress) => {
		setProgress((previous) => {
			const next = { ...previous, [card.id]: update(previous[card.id] ?? newCardProgress(card.id)) };
			saveProgress(next);
			return next;
		});
	};

	const goToNextCard = () => {
		if (cardIndex >= cards.length - 1) {
			onComplete(results.current.correct, results.current.incorrect);
			return;
		}
		setCardIndex(cardIndex + 1);
		setAnswer('');
		setAnswerState('idle');
		setMatchScore(0);
	};

	const handleCheck = () => {
		const typed = answer.trim();
		if (!typed) {
			return;
		}
		const result = isEnglishToArabic ? checkAnswer(typed, card.accepted, card.arabicVariants) : checkEnglish(typed, card.english);
		results.current[result.passed ? 'correct' : 'incorrect'].push(card);
		// A correct answer counts as a 3 on the sm-2 scale, a wrong one as a 1
		updateProgress((current) => updateMastery(calculateNextReview(current, result.passed ? 3 : 1), result.passed));
		setMatchScore(result.score);
		setAnswerState(result.passed ? 'correct' : 'incorrect');
		if (result.passed) {
			setTimeout(goToNextCard, CORRECT_PAUSE_MS);
		}
	};

	const handleNext = () => {
		goToNextCard();
		setTimeout(() => inputRef.current?.focus(), 80);
	};

	const handleDismiss = () => updateProgress(dismissCard);

	if (mode === 'browse') {
		const query = searchQuery.trim();
		const shown = query
			? cards.filter(
					(item) =>
						item.english.toLowerCase().includes(query.toLowerCase()) ||
						item.arabic.includes(query) ||
						item.transliteration.toLowerCase().includes(query.toLowerCase()),
				)
			: cards;

		return (
			<div className="flex flex-col h-full safe-top">
				<Header title="Browse" detail={`${shown.length} cards`} onBack={onBack} />
				<div className="px-4 pt-3 pb-2 flex-shrink-0">
					<input
						value={searchQuery}
						onChange={(e) => setSearchQuery(e.target.value)}
						placeholder="Search English, Arabic or transliteration…"
						className="w-full bg-surfaceHigh rounded-2xl px-4 py-3 text-white placeholder-textSecondary outline-none border border-transparent focus:border-primary transition-colors"
					/>
				</div>
				<div className="flex-1 overflow-y-auto px-4 py-2 space-y-2 safe-bottom">
					{shown.map((item) => (
						<div key={item.id} className="bg-surface border border-border rounded-2xl px-4 py-3.5 flex items-center gap-3">
							<div className="flex-1 min-w-0">
								<div className="flex items-baseline gap-3">
									<p className="arabic-text text-white text-2xl leading-relaxed">{item.arabic}</p>
									<p className="text-primary text-sm font-medium">{item.transliteration}</p>
								</div>
								<p className="text-textSecondary text-xs mt-0.5">{item.english}</p>
							</div>
							<button
								onClick={() => playAudio(item.audio.ar).catch(() => {})}
								className="w-10 h-10 rounded-full bg-surfaceHigh flex items-center justify-center flex-shrink-0 pressable"
								aria-label="Play Arabic"
							>
								<span className="text-primary text-base">▶</span>
							</button>
						</div>
					))}
				</div>
			</div>
		);
	}

	const isMastered = progress[card.id]?.mastered ?? false;

	return (
		<div className="flex flex-col h-full safe-top">
			<Header title={STUDY_MODE_LABELS[mode]} detail={`${cardIndex + 1} / ${cards.length}`} onBack={onBack} />

			<div className="flex-1 flex flex-col px-5 py-5 gap-4 overflow-y-auto">
				<div
					className={`bg-surface border border-border rounded-3xl px-6 py-6 flex justify-between gap-4 ${isEnglishToArabic ? 'items-center' : 'items-start'}`}
					style={{ minHeight: '110px' }}
				>
					{isEnglishToArabic ? (
						<p className="text-white text-2xl font-semibold leading-snug flex-1">{card.english}</p>
					) : (
						<div className="flex-1 min-w-0">
							<p className="arabic-text text-white text-4xl leading-relaxed">{card.arabic}</p>
							<p className="text-primary text-lg font-medium mt-2">{card.transliteration}</p>
						</div>
					)}
					<button
						onClick={() => playAudio(isEnglishToArabic ? card.audio.en : card.audio.ar).catch(() => {})}
						className="w-11 h-11 rounded-full bg-surfaceHigh flex items-center justify-center flex-shrink-0 pressable"
						aria-label="Play again"
					>
						<span className="text-lg">🔊</span>
					</button>
				</div>

				{answerState !== 'idle' && (
					<FeedbackPanel
						card={card}
						answer={answer}
						answerState={answerState}
						matchScore={matchScore}
						revealArabic={isEnglishToArabic}
						isMastered={isMastered}
						onDismiss={handleDismiss}
					/>
				)}

				{answerState === 'idle' && (
					<div className="space-y-3">
						<input
							ref={inputRef}
							value={answer}
							onChange={(e) => setAnswer(e.target.value)}
							onKeyDown={(e) => {
								if (e.key === 'Enter') {
									handleCheck();
								}
							}}
							placeholder={isEnglishToArabic ? 'Type the transliteration…' : 'Type the English meaning…'}
							autoCorrect="off"
							autoCapitalize="none"
							autoComplete="off"
							spellCheck={false}
							className={inputClass}
						/>
						<button
							onClick={handleCheck}
							disabled={!answer.trim()}
							className="w-full bg-primary rounded-2xl py-4 text-white font-semibold pressable disabled:opacity-40"
						>
							Check
						</button>
					</div>
				)}

				{answerState === 'incorrect' && (
					<button
						onClick={handleNext}
						className="fade-in w-full bg-surfaceHigh border border-border rounded-2xl py-4 text-white font-semibold pressable"
					>
						Next →
					</button>
				)}

				{/* Skipping doesn't count for or against the card. Hidden during the pause after a correct answer so it can't skip two */}
				{answerState !== 'correct' && (
					<button onClick={goToNextCard} className="text-textSecondary text-sm text-center pressable py-2">
						Skip
					</button>
				)}
			</div>
		</div>
	);
}
