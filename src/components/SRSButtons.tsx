import type { SRSGrade } from '../types'

interface Props {
  onGrade: (grade: SRSGrade) => void
}

const GRADES: { grade: SRSGrade; label: string; sub: string; color: string }[] = [
  { grade: 1, label: 'Again', sub: '1 day',  color: 'bg-danger/20 border-danger/40 text-danger' },
  { grade: 2, label: 'Hard',  sub: '3 days', color: 'bg-warning/20 border-warning/40 text-warning' },
  { grade: 3, label: 'Good',  sub: '~6 days', color: 'bg-success/20 border-success/40 text-success' },
  { grade: 4, label: 'Easy',  sub: 'long',   color: 'bg-primary/20 border-primary/40 text-primary' },
]

export default function SRSButtons({ onGrade }: Props) {
  return (
    <div className="slide-up grid grid-cols-4 gap-2 w-full">
      {GRADES.map(({ grade, label, sub, color }) => (
        <button
          key={grade}
          onClick={() => onGrade(grade)}
          className={`${color} border rounded-2xl py-3 flex flex-col items-center gap-0.5 pressable`}
        >
          <span className="font-semibold text-sm">{label}</span>
          <span className="text-xs opacity-70">{sub}</span>
        </button>
      ))}
    </div>
  )
}
