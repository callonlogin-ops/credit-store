import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
export async function GET() { const apps = await prisma.app.findMany({ where: { status: 'APPROVED' }, orderBy: { createdAt: 'desc' }, select: { id: true, title: true, slug: true, description: true, category: true, version: true, iconUrl: true, downloads: true, developer: { select: { companyName: true } } } }); return NextResponse.json({ apps }); }
