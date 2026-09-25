import { useEffect, useState } from 'react';
import AdminScreen from './components/AdminScreen';
import CategoryScreen from './components/CategoryScreen';
import HomeScreen from './components/HomeScreen';
import StudyScreen from './components/StudyScreen';
import SummaryScreen from './components/SummaryScreen';
import { fetchCardsFromSupabase, getInitialCards } from './lib/cards';
import type { AppScreen, Card } from './types';

export default function App() {
	const [screen, setScreen] = useState<AppScreen>({ type: 'home' });
	const [cards, setCards] = useState<Card[]>(getInitialCards);

	const reloadCards = () => {
		fetchCardsFromSupabase()
			.then(setCards)
			.catch(() => {
				// Offline or no supabase set up - the cards we already have are fine
			});
	};

	// Start with the cached or bundled cards so there's no loading screen, then swap in the live ones from supabase if that works
	useEffect(reloadCards, []);

	const backToCategory = (category: string) => setScreen({ type: 'category', categoryName: category });

	return (
		<div className="h-full bg-bg text-textPrimary overflow-hidden">
			{screen.type === 'home' && (
				<HomeScreen
					cards={cards}
					onCategory={(name) => setScreen({ type: 'category', categoryName: name })}
					onAdmin={() => setScreen({ type: 'admin' })}
				/>
			)}

			{screen.type === 'category' && (
				<CategoryScreen
					cards={cards}
					categoryName={screen.categoryName}
					onBack={() => setScreen({ type: 'home' })}
					onStart={(mode, sessionName, sessionCards) =>
						setScreen({ type: 'study', mode, category: screen.categoryName, sessionName, cards: sessionCards })
					}
				/>
			)}

			{screen.type === 'study' && (
				<StudyScreen
					mode={screen.mode}
					cards={screen.cards}
					onBack={() => backToCategory(screen.category)}
					onComplete={(correct, incorrect) =>
						setScreen({
							type: 'summary',
							mode: screen.mode,
							category: screen.category,
							sessionName: screen.sessionName,
							cards: screen.cards,
							correct,
							incorrect,
						})
					}
				/>
			)}

			{screen.type === 'summary' && (
				<SummaryScreen
					mode={screen.mode}
					category={screen.category}
					sessionName={screen.sessionName}
					cards={screen.cards}
					correct={screen.correct}
					incorrect={screen.incorrect}
					onRetry={() =>
						setScreen({ type: 'study', mode: screen.mode, category: screen.category, sessionName: screen.sessionName, cards: screen.cards })
					}
					onReviewWrong={() =>
						setScreen({
							type: 'study',
							mode: screen.mode,
							category: screen.category,
							sessionName: screen.sessionName,
							cards: screen.incorrect,
						})
					}
					onBack={() => backToCategory(screen.category)}
				/>
			)}

			{screen.type === 'admin' && <AdminScreen cards={cards} onBack={() => setScreen({ type: 'home' })} onSaved={reloadCards} />}
		</div>
	);
}
