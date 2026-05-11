import { useState } from 'react'
import type { Screen, StudyMode } from './types'
import HomeScreen from './components/HomeScreen'
import StudyScreen from './components/StudyScreen'
import AdminScreen from './components/AdminScreen'

export default function App() {
  const [screen, setScreen] = useState<Screen>('home')
  const [studyMode, setStudyMode] = useState<StudyMode>('flashcard')

  const handleStartStudy = (mode: StudyMode) => {
    setStudyMode(mode)
    setScreen('study')
  }

  return (
    <div className="h-full bg-bg text-textPrimary overflow-hidden">
      {screen === 'home' && (
        <HomeScreen
          onStartStudy={handleStartStudy}
          onAdmin={() => setScreen('admin')}
        />
      )}

      {screen === 'study' && (
        <StudyScreen
          mode={studyMode}
          onBack={() => setScreen('home')}
        />
      )}

      {screen === 'admin' && (
        <AdminScreen
          onBack={() => setScreen('home')}
        />
      )}
    </div>
  )
}
