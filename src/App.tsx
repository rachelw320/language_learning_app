import { useState, useEffect } from 'react'
import type { User } from '@supabase/supabase-js'
import { supabase } from './lib/supabase'
import type { Screen, StudyMode } from './types'
import AuthScreen from './components/AuthScreen'
import HomeScreen from './components/HomeScreen'
import StudyScreen from './components/StudyScreen'

export default function App() {
  const [screen, setScreen] = useState<Screen>('auth')
  const [user, setUser] = useState<User | null>(null)
  const [studyMode, setStudyMode] = useState<StudyMode>('flashcard')
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // Check if user is already signed in
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(session?.user ?? null)
      setScreen(session?.user ? 'home' : 'auth')
      setLoading(false)
    })

    // Listen for sign-in / sign-out events
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null)
      setScreen(session?.user ? 'home' : 'auth')
    })

    return () => subscription.unsubscribe()
  }, [])

  const handleStartStudy = (mode: StudyMode) => {
    setStudyMode(mode)
    setScreen('study')
  }

  const handleSignOut = async () => {
    await supabase.auth.signOut()
  }

  if (loading) {
    return (
      <div className="flex h-full items-center justify-center bg-bg">
        <div className="w-8 h-8 rounded-full border-2 border-primary border-t-transparent animate-spin" />
      </div>
    )
  }

  return (
    <div className="h-full bg-bg text-textPrimary overflow-hidden">
      {screen === 'auth' && <AuthScreen />}

      {screen === 'home' && user && (
        <HomeScreen
          user={user}
          onStartStudy={handleStartStudy}
          onSignOut={handleSignOut}
        />
      )}

      {screen === 'study' && user && (
        <StudyScreen
          user={user}
          mode={studyMode}
          onBack={() => setScreen('home')}
        />
      )}
    </div>
  )
}
