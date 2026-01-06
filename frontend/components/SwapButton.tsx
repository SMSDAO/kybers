'use client'

interface SwapButtonProps {
  onClick: () => void
  disabled?: boolean
}

export default function SwapButton({ onClick, disabled = false }: SwapButtonProps) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`w-full py-4 rounded-xl font-bold text-lg transition-all duration-300 ${
        disabled
          ? 'bg-gray-600 text-gray-400 cursor-not-allowed'
          : 'btn-neon animate-glow hover:scale-105 active:scale-95'
      }`}
    >
      {disabled ? 'Enter Amount' : 'Swap Now'}
    </button>
  )
}
