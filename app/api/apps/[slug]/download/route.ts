import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { currentSession } from '@/lib/session';

export async function GET(_: Request, { params }: { params: { slug: string } }) {
  const app = await prisma.app.findUnique({ where: { slug: params.slug } });
  if (!app || app.status !== 'APPROVED') {
    return NextResponse.json({ error: 'Aplicativo não encontrado' }, { status: 404 });
  }

  const session = await currentSession();
  await prisma.$transaction([
    prisma.app.update({ where: { id: app.id }, data: { downloads: { increment: 1 } } }),
    prisma.download.create({ data: { appId: app.id, userId: session?.userId } }),
  ]);

  return NextResponse.redirect(app.fileUrl, 302);
}
