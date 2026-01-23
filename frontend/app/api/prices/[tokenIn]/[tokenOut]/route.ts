import { NextResponse } from 'next/server'

export async function GET(
  request: Request,
  { params }: { params: { tokenIn: string; tokenOut: string } }
) {
  const { tokenIn, tokenOut } = params

  // TODO: Implement actual price aggregation
  // This is mock data matching the original Express backend
  const response = {
    tokenIn,
    tokenOut,
    prices: [
      { dex: 'Uniswap V3', price: 1834.52 },
      { dex: 'Sushiswap', price: 1832.18 },
      { dex: 'Curve', price: 1835.67 },
    ],
    bestPrice: 1835.67,
    bestDex: 'Curve',
  }

  return NextResponse.json(response)
}
