import { getCardsForCategory, getCategories } from '../lib/categories';
import { loadProgress } from '../lib/progress';
import { MASTERY_STREAK } from '../lib/srs';
import type { Card } from '../types';

interface Props {
	cards: Card[];
	onCategory: (name: string) => void;
	onAdmin: () => void;
}

// Icons for the category tiles. Anything not listed here gets the book
const CATEGORY_ICONS: Record<string, string> = {
	'Top 50 Essentials': '⭐',
	'Core Verbs': '🔤',
};
const DEFAULT_CATEGORY_ICON = '📚';

// How many recently studied cards to show at the top
const RECENT_COUNT = 6;

function percent(part: number, whole: number): number {
	return whole > 0 ? Math.round((part / whole) * 100) : 0;
}

export default function HomeScreen({ cards, onCategory, onAdmin }: Props) {
	const categories = getCategories(cards);
	const progress = loadProgress();

	const masteredCount = cards.filter((card) => progress[card.id]?.mastered).length;
	const masteryPercent = percent(masteredCount, cards.length);

	// The cards studied most recently, newest first
	const recentCards = cards
		.filter((card) => progress[card.id]?.lastReviewed)
		.sort((a, b) => new Date(progress[b.id].lastReviewed!).getTime() - new Date(progress[a.id].lastReviewed!).getTime())
		.slice(0, RECENT_COUNT);

	return (
		<div className="flex flex-col h-full safe-top safe-bottom">
			<div className="flex items-center justify-between px-5 py-4 border-b border-border flex-shrink-0">
				<div>
					<h1 className="text-lg font-semibold text-white">Egyptian Arabic</h1>
					<p className="text-textSecondary text-xs mt-0.5">
						{cards.length} cards · {categories.length} categories
					</p>
				</div>
				<button
					onClick={onAdmin}
					className="w-9 h-9 rounded-full bg-surfaceHigh flex items-center justify-center text-primary text-xl pressable leading-none"
					aria-label="Add a card"
				>
					+
				</button>
			</div>

			<div className="flex-1 scroll-area px-5 py-5 space-y-5">
				<div className="bg-surface border border-border rounded-2xl px-4 py-4">
					<div className="flex items-baseline justify-between mb-2">
						<p className="text-white text-sm font-semibold">Mastery</p>
						<p className="text-textSecondary text-xs">
							{masteredCount} / {cards.length} mastered
						</p>
					</div>
					<div className="w-full h-2 bg-surfaceHigh rounded-full overflow-hidden">
						<div className="h-full bg-primary rounded-full transition-all" style={{ width: `${masteryPercent}%` }} />
					</div>
					<p className="text-textSecondary text-xs mt-1.5">
						{masteryPercent}% · a card is mastered after {MASTERY_STREAK} correct answers on different days
					</p>
				</div>

				{recentCards.length > 0 && (
					<div className="space-y-2">
						<p className="text-textSecondary text-xs font-medium uppercase tracking-wider px-1">Recently studied</p>
						<div className="grid grid-cols-2 gap-2">
							{recentCards.map((card) => {
								const streak = progress[card.id]?.masteryStreak ?? 0;
								return (
									<div key={card.id} className="bg-surface border border-border rounded-2xl px-3 py-2.5">
										<p className="arabic-text text-white text-xl leading-relaxed">{card.arabic}</p>
										<p className="text-textSecondary text-xs mt-0.5 truncate">{card.english}</p>
										<div className="flex gap-0.5 mt-1.5">
											{Array.from({ length: MASTERY_STREAK }, (_, i) => (
												<div key={i} className={`h-1 flex-1 rounded-full ${i < streak ? 'bg-primary' : 'bg-surfaceHigh'}`} />
											))}
										</div>
									</div>
								);
							})}
						</div>
					</div>
				)}

				<div className="space-y-3">
					<p className="text-textSecondary text-xs font-medium uppercase tracking-wider px-1">Categories</p>
					{categories.map((category, i) => {
						const categoryCards = getCardsForCategory(cards, category);
						const mastered = categoryCards.filter((card) => progress[card.id]?.mastered).length;
						// The first category gets the blue highlight
						const highlighted = i === 0;
						return (
							<button
								key={category}
								onClick={() => onCategory(category)}
								className={`w-full rounded-3xl px-5 py-5 flex items-center gap-4 pressable text-left ${
									highlighted ? 'bg-primary/10 border border-primary/20' : 'bg-surface border border-border'
								}`}
							>
								<div
									className={`w-12 h-12 rounded-2xl flex items-center justify-center flex-shrink-0 text-2xl ${
										highlighted ? 'bg-primary/20' : 'bg-surfaceHigh'
									}`}
								>
									{CATEGORY_ICONS[category] ?? DEFAULT_CATEGORY_ICON}
								</div>
								<div className="flex-1 min-w-0">
									<p className="font-semibold text-white text-base">{category}</p>
									<p className={`text-sm mt-0.5 ${highlighted ? 'text-primary/80' : 'text-textSecondary'}`}>
										{categoryCards.length} cards · {percent(mastered, categoryCards.length)}% mastered
									</p>
								</div>
								<span className={`text-lg ${highlighted ? 'text-primary opacity-60' : 'text-textTertiary'}`}>›</span>
							</button>
						);
					})}
				</div>
			</div>
		</div>
	);
}
