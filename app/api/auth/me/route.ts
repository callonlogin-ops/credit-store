import { NextResponse } from 'next/server';
import { currentSession } from '@/lib/session';
import { prisma } from '@/lib/prisma';
export async function GET() { const session = await currentSession(); if (!session) return NextResponse.json({ user: null }); const user = await prisma.user.findUnique({ where: { id: session.userId }, select: { id: true, name: true, email: true, role: true } }); return NextResponse.json({ user }); }
