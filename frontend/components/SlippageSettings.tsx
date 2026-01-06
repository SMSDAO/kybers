'use client'

interface SlippageSettingsProps {
  value: number
  onChange: (value: number) => void
}

const PRESET_VALUES = [0.1, 0.5, 1.0]

export default function SlippageSettings({ value, onChange }: SlippageSettingsProps) {
  return (
    <div className="glass rounded-lg p-4 space-y-3">
      <div className="flex justify-between items-center">
        <span className="text-sm font-semibold text-neon-cyan">Slippage Tolerance</span>
        <span className="text-sm text-neon-green">{value}%</span>
      </div>

      {/* Preset Buttons */}
      <div className="flex space-x-2">
        {PRESET_VALUES.map((preset) => (
          <button
            key={preset}
            onClick={() => onChange(preset)}
            className={`flex-1 py-2 px-4 rounded-lg transition-all duration-300 ${
              value === preset
                ? 'bg-neon-purple text-white glow-purple'
                : 'glass text-neon-cyan hover:glow-cyan'
            }`}
          >
            {preset}%
          </button>
        ))}
      </div>

      {/* Custom Input */}
      <div className="flex items-center space-x-2">
        <input
          type="number"
          value={value}
          onChange={(e) => onChange(parseFloat(e.target.value) || 0)}
          step="0.1"
          min="0"
          max="50"
          className="flex-1 px-4 py-2 rounded-lg glass border-2 border-neon-purple/30 focus:border-neon-purple outline-none text-neon-cyan"
        />
        <span className="text-neon-cyan">%</span>
      </div>

      <p className="text-xs text-neon-cyan/50">
        Your transaction will revert if the price changes unfavorably by more than this percentage.
      </p>
    </div>
  )
}
