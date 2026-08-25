import type { NextRequest } from 'next/server'
import { NextResponse } from 'next/server'

export function middleware(request: NextRequest) {
  // Simple placeholder: Check for auth cookie/session
  return NextResponse.next()
}
