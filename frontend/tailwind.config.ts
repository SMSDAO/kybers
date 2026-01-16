import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        'neon-cyan': '#00fff9',
        'neon-purple': '#b537f2',
        'neon-green': '#39ff14',
        'neon-pink': '#ff006e',
        'dark-bg': '#0a0e27',
        'dark-card': '#1a1f3a',
      },
      backgroundImage: {
        'cyber-grid': 'linear-gradient(rgba(0, 255, 249, 0.1) 1px, transparent 1px), linear-gradient(90deg, rgba(0, 255, 249, 0.1) 1px, transparent 1px)',
      },
      backgroundSize: {
        'grid': '50px 50px',
      },
      boxShadow: {
        'neon-cyan': '0 0 20px rgba(0, 255, 249, 0.5)',
        'neon-purple': '0 0 20px rgba(181, 55, 242, 0.5)',
        'neon-green': '0 0 20px rgba(57, 255, 20, 0.5)',
        'neon-pink': '0 0 20px rgba(255, 0, 110, 0.5)',
      },
      animation: {
        'glow-pulse': 'glow-pulse 2s ease-in-out infinite',
        'shimmer': 'shimmer 2s linear infinite',
        'float': 'float 3s ease-in-out infinite',
      },
      keyframes: {
        'glow-pulse': {
          '0%, 100%': { boxShadow: '0 0 20px rgba(0, 255, 249, 0.5)' },
          '50%': { boxShadow: '0 0 40px rgba(0, 255, 249, 0.8)' },
        },
        'shimmer': {
          '0%': { backgroundPosition: '-200% 0' },
          '100%': { backgroundPosition: '200% 0' },
        },
        'float': {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-20px)' },
        },
      },
    },
  },
  plugins: [],
}

export default config
