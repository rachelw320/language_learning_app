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
        danger: '#ff453a',
        textPrimary: '#ffffff',
        textSecondary: '#8e8e93',
        textTertiary: '#48484a',
      },
      fontFamily: {
        sans: ['-apple-system', 'BlinkMacSystemFont', 'SF Pro Display', 'Segoe UI', 'sans-serif'],
        arabic: ['Geeza Pro', 'Arial Unicode MS', 'sans-serif'],
      },
    },
  },
  plugins: [],
}
