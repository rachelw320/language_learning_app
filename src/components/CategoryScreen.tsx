import { getCardsForCategory, getTagGroups, getVerbGroups, isVerbCategory, shuffle } from '../lib/categories';
import { loadProgress } from '../lib/progress';
import { isDismissed } from '../lib/srs';
import type { Card, StudyMode } from '../types';

interface Props {
	cards: Card[];
	categoryName: string;
	onBack: () => void;
	onStart: (mode: StudyMode, sessionName: string, cards: Card[]) => void;
}

const MIX_ALL = 'Mix all';

interface TileProps {
	icon: string;
	title: string;
	subtitle: string;
	highlighted?: boolean;
	onClick: () => void;
}

function ModeTile({ icon, title, subtitle, highlighted = false, onClick }: TileProps) {
	return (
		<button
			onClick={onClick}
			className={`w-full rounded-3xl px-5 py-5 flex items-center gap-4 pressable text-left ${
				highlighted ? 'bg-primary/10 border border-primary/20' : 'bg-surface border border-border'
			}`}
		>
			<div
				className={`w-12 h-12 rounded-2xl flex items-center justify-center flex-shrink-0 text-2xl ${
					highlighted ? 'bg-primary/20' : 'bg-surfaceHigh'
				}`}
			>
				{icon}
			</div>
			<div className="flex-1 min-w-0">
				<p className="font-semibold text-white text-base">{title}</p>
				<p className={`text-sm mt-0.5 ${highlighted ? 'text-primary/80' : 'text-textSecondary'}`}>{subtitle}</p>
			</div>
			<span className={`text-lg ${highlighted ? 'text-primary opacity-60' : 'text-textTertiary'}`}>›</span>
		</button>
	);
}

export default function CategoryScreen({ cards, categoryName, onBack, onStart }: Props) {
	const progress = loadProgress();
	// Leave out anything dismissed for the week
	const categoryCards = getCardsForCategory(cards, categoryName).filter((card) => !isDismissed(progress[card.id]));

	const isVerb = isVerbCategory(categoryCards);
	const groups = isVerb ? getVerbGroups(categoryCards) : getTagGroups(categoryCards);
	// Topic groups are only worth showing when there's more than one and at least one has a few cards in it
	const showGroups = isVerb || (groups.length >= 2 && groups.some((group) => group.cards.length >= 2));

	const startMix = (mode: StudyMode) => onStart(mode, MIX_ALL, shuffle(categoryCards));

	return (
		<div className="flex flex-col h-full safe-top safe-bottom">
			<div className="flex items-center justify-between px-5 pt-4 pb-3 border-b border-border flex-shrink-0">
				<button onClick={onBack} className="text-primary pressable text-sm font-medium">
					← Back
				</button>
				<span className="text-white text-sm font-semibold truncate px-2">{categoryName}</span>
				<span className="text-textSecondary text-xs">{categoryCards.length} cards</span>
			</div>

			<div className="flex-1 scroll-area px-5 py-5 space-y-5">
				<div className="space-y-3">
					<p className="text-textSecondary text-xs font-medium uppercase tracking-wider px-1">Study mode</p>
					<ModeTile
						icon="🔊"
						title="English → Arabic"
						subtitle="Hear English · write the transliteration"
						highlighted
						onClick={() => startMix('english-to-arabic')}
					/>
					<ModeTile
						icon="✍️"
						title="Arabic → English"
						subtitle="See Arabic · write the meaning"
						onClick={() => startMix('arabic-to-english')}
					/>
					<ModeTile
						icon="📋"
						title="Browse"
						subtitle="Search and explore all cards"
						onClick={() => onStart('browse', 'Browse', categoryCards)}
					/>

					{/* Fill in the gaps isn't built yet */}
					<div className="w-full bg-surface border border-border rounded-3xl px-5 py-5 flex items-center gap-4 opacity-40 cursor-not-allowed">
						<div className="w-12 h-12 rounded-2xl bg-surfaceHigh flex items-center justify-center flex-shrink-0 text-2xl">✏️</div>
						<div className="flex-1 min-w-0">
							<p className="font-semibold text-white text-base">Fill in the gaps</p>
							<p className="text-textSecondary text-sm mt-0.5">Complete sentences · coming soon</p>
						</div>
						<span className="text-xs text-textTertiary bg-surfaceHigh rounded-lg px-2 py-1 flex-shrink-0">soon</span>
					</div>
				</div>

				{showGroups && (
					<div className="space-y-3">
						<div className="flex items-center justify-between px-1">
							<p className="text-textSecondary text-xs font-medium uppercase tracking-wider">{isVerb ? 'By verb' : 'By topic'}</p>
							<button
								onClick={() => startMix('english-to-arabic')}
								className="flex items-center gap-1.5 bg-primary/10 border border-primary/20 rounded-xl px-3 py-1.5 text-primary text-xs font-semibold pressable"
							>
								{MIX_ALL}
							</button>
						</div>

						<div className="space-y-2">
							{groups.map((group) => (
								<button
									key={group.tag}
									onClick={() => onStart('english-to-arabic', group.label, group.cards)}
									className="w-full bg-surface border border-border rounded-2xl px-4 py-3.5 flex items-center gap-3 pressable text-left"
								>
									<div className="flex-1 min-w-0">
										<div className="flex items-baseline gap-2">
											<p className="text-white text-sm font-semibold">{group.label}</p>
											{group.labelArabic && <p className="arabic-text text-primary text-lg leading-relaxed">{group.labelArabic}</p>}
										</div>
										<p className="text-textSecondary text-xs mt-0.5">
											{isVerb ? `${group.cards.length} conjugations · present` : `${group.cards.length} cards`}
										</p>
									</div>
									<span className="text-textTertiary text-lg">›</span>
								</button>
							))}
						</div>
					</div>
				)}
			</div>
		</div>
	);
}
