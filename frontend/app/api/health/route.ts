import { NextResponse } from 'next/server'

export async function GET() {
  return NextResponse.json({
    status: 'healthy',
    service: 'kybers-backend',
    timestamp: new Date().toISOString(),
  })
}
