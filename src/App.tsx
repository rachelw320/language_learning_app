import { useState } from 'react'
import type { AppScreen } from './types'
import HomeScreen from './components/HomeScreen'
import CategoryScreen from './components/CategoryScreen'
import StudyScreen from './components/StudyScreen'
import SummaryScreen from './components/SummaryScreen'
import AdminScreen from './components/AdminScreen'

export default function App() {
  const [screen, setScreen] = useState<AppScreen>({ type: 'home' })

  return (
    <div className="h-full bg-bg text-textPrimary overflow-hidden">
      {screen.type === 'home' && (
        <HomeScreen
          onCategory={name => setScreen({ type: 'category', categoryName: name })}
          onAdmin={() => setScreen({ type: 'admin' })}
        />
      )}

      {screen.type === 'category' && (
        <CategoryScreen
          categoryName={screen.categoryName}
          onBack={() => setScreen({ type: 'home' })}
          onStart={(mode, category, chunkIndex, cards) =>
            setScreen({ type: 'study', mode, category, chunkIndex, cards })
          }
        />
      )}

      {screen.type === 'study' && (
        <StudyScreen
          mode={screen.mode}
          category={screen.category}
          chunkIndex={screen.chunkIndex}
          cards={screen.cards}
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
            })
          }
        />
      )}

      {screen.type === 'summary' && (
        <SummaryScreen
          mode={screen.mode}
          category={screen.category}
          chunkIndex={screen.chunkIndex}
          correct={screen.correct}
          incorrect={screen.incorrect}
          allCards={screen.allCards}
          onRetry={() =>
            setScreen({
              type: 'study',
              mode: screen.mode,
              category: screen.category,
              chunkIndex: screen.chunkIndex,
              cards: screen.allCards,
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
