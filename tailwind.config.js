/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        // iOS dark mode system colors
        bg: '#000000',
        surface: '#1c1c1e',
        surfaceHigh: '#2c2c2e',
        border: '#38383a',
        primary: '#0a84ff',
        success: '#30d158',
        warning: '#ff9f0a',
        danger: '#ff453a',
        textPrimary: '#ffffff',
        textSecondary: '#8e8e93',
        textTertiary: '#48484a',
      },
      fontFamily: {
        sans: ['-apple-system', 'BlinkMacSystemFont', 'SF Pro Display', 'Segoe UI', 'sans-serif'],
        arabic: ['Geeza Pro', 'Arial Unicode MS', 'sans-serif'],
      },
      animation: {
        'flip-in': 'flipIn 0.4s ease forwards',
        'slide-up': 'slideUp 0.3s ease forwards',
        'pulse-ring': 'pulseRing 1.5s ease infinite',
      },
      keyframes: {
        flipIn: {
          '0%': { transform: 'rotateY(90deg)', opacity: '0' },
          '100%': { transform: 'rotateY(0deg)', opacity: '1' },
        },
        slideUp: {
          '0%': { transform: 'translateY(20px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
        pulseRing: {
          '0%, 100%': { transform: 'scale(1)', opacity: '1' },
          '50%': { transform: 'scale(1.1)', opacity: '0.8' },
        },
      },
    },
  },
  plugins: [],
}
