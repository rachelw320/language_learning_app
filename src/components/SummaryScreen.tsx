import { playAudio } from '../lib/audio';
import { STUDY_MODE_LABELS } from '../lib/modes';
import type { Card, StudyMode } from '../types';

interface Props {
	mode: StudyMode;
	category: string;
	sessionName: string;
	cards: Card[];
	correct: Card[];
	incorrect: Card[];
	onRetry: () => void;
	onReviewWrong: () => void;
	onBack: () => void;
}

// The score you need for the green circle
const PASS_MARK = 80;

export default function SummaryScreen({ mode, category, sessionName, cards, correct, incorrect, onRetry, onReviewWrong, onBack }: Props) {
	const score = cards.length > 0 ? Math.round((correct.length / cards.length) * 100) : 0;
	const passed = score >= PASS_MARK;

	return (
		<div className="flex flex-col h-full safe-top safe-bottom">
			<div className="flex items-center justify-between px-5 pt-4 pb-3 border-b border-border flex-shrink-0">
				<button onClick={onBack} className="text-primary pressable text-sm font-medium">
					← Back
				</button>
				<span className="text-textSecondary text-sm font-medium">
					{STUDY_MODE_LABELS[mode]} · {sessionName}
				</span>
				<span className="text-textSecondary text-xs">{category}</span>
			</div>

			<div className="flex-1 overflow-y-auto px-5 py-6 space-y-5">
				<div className="flex flex-col items-center gap-2 py-4">
					<div
						className={`w-24 h-24 rounded-full flex items-center justify-center border-4 ${
							passed ? 'border-success bg-success/10' : 'border-danger bg-danger/10'
						}`}
					>
						<span className={`text-3xl font-bold ${passed ? 'text-success' : 'text-danger'}`}>{score}%</span>
					</div>
					<p className="text-white font-semibold text-lg">{passed ? 'Great work!' : 'Keep practising'}</p>
					<p className="text-textSecondary text-sm">
						<span className="text-success font-medium">{correct.length} correct</span> ·{' '}
						<span className="text-danger font-medium">{incorrect.length} incorrect</span>
					</p>
				</div>

				<div className="space-y-3">
					{incorrect.length > 0 && (
						<button
							onClick={onReviewWrong}
							className="w-full bg-danger/10 border border-danger/30 rounded-2xl py-4 text-danger font-semibold pressable"
						>
							Review {incorrect.length} incorrect {incorrect.length === 1 ? 'card' : 'cards'}
						</button>
					)}
					<button onClick={onRetry} className="w-full bg-primary rounded-2xl py-4 text-white font-semibold pressable">
						Try again
					</button>
					<button onClick={onBack} className="w-full text-textSecondary text-sm text-center pressable py-2">
						Back to {category}
					</button>
				</div>

				{incorrect.length > 0 && (
					<div className="space-y-2">
						<p className="text-textSecondary text-xs font-medium uppercase tracking-wider px-1">Missed cards</p>
						{incorrect.map((card) => (
							<div key={card.id} className="bg-surface border border-border rounded-2xl px-4 py-3.5 flex items-center gap-3">
								<div className="flex-1 min-w-0">
									<div className="flex items-baseline gap-2 flex-wrap">
										<p className="arabic-text text-white text-2xl leading-relaxed">{card.arabic}</p>
										<p className="text-primary text-sm font-medium">{card.transliteration}</p>
									</div>
									<p className="text-textSecondary text-xs mt-0.5">{card.english}</p>
								</div>
								<button
									onClick={() => playAudio(card.audio.ar).catch(() => {})}
									className="w-9 h-9 rounded-full bg-surfaceHigh flex items-center justify-center flex-shrink-0 pressable"
									aria-label="Play Arabic"
								>
									<span className="text-primary text-sm">▶</span>
								</button>
							</div>
						))}
					</div>
				)}
			</div>
		</div>
	);
}
