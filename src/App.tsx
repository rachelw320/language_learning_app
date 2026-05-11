import { useState, useEffect } from 'react'
import type { AppScreen, Card } from './types'
import HomeScreen from './components/HomeScreen'
import CategoryScreen from './components/CategoryScreen'
import StudyScreen from './components/StudyScreen'
import SummaryScreen from './components/SummaryScreen'
import AdminScreen from './components/AdminScreen'
import { getInitialCards, fetchCardsFromSupabase } from './lib/cards'

export default function App() {
  const [screen, setScreen] = useState<AppScreen>({ type: 'home' })
  const [cards, setCards] = useState<Card[]>(getInitialCards)

  useEffect(() => {
    fetchCardsFromSupabase()
      .then(setCards)
      .catch(() => { /* already using cached/bundled cards */ })
  }, [])

  return (
    <div className="h-full bg-bg text-textPrimary overflow-hidden">
      {screen.type === 'home' && (
        <HomeScreen
          cards={cards}
          onCategory={name => setScreen({ type: 'category', categoryName: name })}
          onAdmin={() => setScreen({ type: 'admin' })}
        />
      )}

      {screen.type === 'category' && (
        <CategoryScreen
          cards={cards}
          categoryName={screen.categoryName}
          onBack={() => setScreen({ type: 'home' })}
          onStart={(mode, category, chunkIndex, sessionCards, isMix) =>
            setScreen({ type: 'study', mode, category, chunkIndex, cards: sessionCards, isMix })
          }
        />
      )}

      {screen.type === 'study' && (
        <StudyScreen
          mode={screen.mode}
          category={screen.category}
          chunkIndex={screen.chunkIndex}
          cards={screen.cards}
          isMix={screen.isMix}
          onBack={() => setScreen({ type: 'category', categoryName: screen.category })}
          onComplete={(correct, incorrect) =>
            setScreen({
              type: 'summary',
              mode: screen.mode,
              category: screen.category,
              chunkIndex: screen.chunkIndex,
              correct,
              incorrect,
              allCards: screen.cards,
              isMix: screen.isMix,
            })
          }
        />
      )}

      {screen.type === 'summary' && (
        <SummaryScreen
          cards={cards}
          mode={screen.mode}
          category={screen.category}
          chunkIndex={screen.chunkIndex}
          correct={screen.correct}
          incorrect={screen.incorrect}
          allCards={screen.allCards}
          isMix={screen.isMix}
          onRetry={() =>
            setScreen({
              type: 'study',
              mode: screen.mode,
              category: screen.category,
              chunkIndex: screen.chunkIndex,
              cards: screen.allCards,
              isMix: screen.isMix,
            })
          }
          onReviewWrong={() =>
            setScreen({
              type: 'study',
              mode: screen.mode,
              category: screen.category,
              chunkIndex: screen.chunkIndex,
              cards: screen.incorrect,
            })
          }
          onNextSet={(nextChunkIndex, nextCards) =>
            setScreen({
              type: 'study',
              mode: screen.mode,
              category: screen.category,
              chunkIndex: nextChunkIndex,
              cards: nextCards,
            })
          }
          onBack={() => setScreen({ type: 'category', categoryName: screen.category })}
        />
      )}

      {screen.type === 'admin' && (
        <AdminScreen onBack={() => setScreen({ type: 'home' })} />
      )}
    </div>
  )
}
