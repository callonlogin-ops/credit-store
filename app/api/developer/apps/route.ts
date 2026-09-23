import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { currentSession } from '@/lib/session';
export async function GET() { const session = await currentSession(); if (!session || !['DEVELOPER', 'ADMIN'].includes(session.role)) return NextResponse.json({ error: 'Não autorizado' }, { status: 401 }); const apps = await prisma.app.findMany({ where: session.role === 'ADMIN' ? {} : { ownerId: session.userId }, orderBy: { createdAt: 'desc' } }); return NextResponse.json({ apps }); }
