import { useState } from 'react'
import { supabase } from '../lib/supabase'

export default function AuthScreen() {
  const [email, setEmail] = useState('')
  const [sent, setSent] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  const handleSendLink = async () => {
    if (!email.trim()) return
    setLoading(true)
    setError('')

    const { error } = await supabase.auth.signInWithOtp({
      email: email.trim(),
      options: { emailRedirectTo: window.location.origin },
    })

    if (error) {
      setError(error.message)
    } else {
      setSent(true)
    }
    setLoading(false)
  }

  return (
    <div className="flex flex-col h-full items-center justify-center px-6 safe-top safe-bottom">
      <div className="w-full max-w-sm space-y-8">
        {/* Logo / title */}
        <div className="text-center space-y-2">
          <div className="text-5xl font-bold arabic-text text-white">مصري</div>
          <div className="text-textSecondary text-base">Egyptian Arabic</div>
        </div>

        {sent ? (
          <div className="text-center space-y-4">
            <div className="text-4xl">📬</div>
            <p className="text-textPrimary font-medium">Check your email</p>
            <p className="text-textSecondary text-sm">
              Tap the link we sent to <span className="text-white">{email}</span> to sign in.
            </p>
            <button
              onClick={() => setSent(false)}
              className="text-primary text-sm pressable"
            >
              Use a different email
            </button>
          </div>
        ) : (
          <div className="space-y-4">
            <input
              type="email"
              value={email}
              onChange={e => setEmail(e.target.value)}
              onKeyDown={e => e.key === 'Enter' && handleSendLink()}
              placeholder="your@email.com"
              autoComplete="email"
              className="w-full bg-surface border border-border rounded-2xl px-4 py-4 text-textPrimary placeholder-textSecondary text-base outline-none focus:border-primary transition-colors"
            />

            {error && <p className="text-danger text-sm text-center">{error}</p>}

            <button
              onClick={handleSendLink}
              disabled={loading || !email.trim()}
              className="w-full bg-primary rounded-2xl py-4 text-white font-semibold text-base pressable disabled:opacity-40 disabled:cursor-not-allowed"
            >
              {loading ? 'Sending…' : 'Send sign-in link'}
            </button>

            <p className="text-textSecondary text-xs text-center">
              No password needed — we email you a magic link.
            </p>
          </div>
        )}
      </div>
    </div>
  )
}
