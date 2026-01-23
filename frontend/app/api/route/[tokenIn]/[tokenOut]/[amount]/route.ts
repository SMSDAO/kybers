import { NextResponse } from 'next/server'

export async function GET(
  request: Request,
  { params }: { params: { tokenIn: string; tokenOut: string; amount: string } }
) {
  const { tokenIn, tokenOut, amount } = params

  // TODO: Implement actual route calculation
  // This is mock data matching the original Express backend
  const response = {
    route: [
      { dex: 'Uniswap V3', percentage: 100 },
    ],
    expectedOutput: parseFloat(amount) * 1834.52,
    priceImpact: 0.05,
    gasEstimate: 150000,
  }

  return NextResponse.json(response)
}
