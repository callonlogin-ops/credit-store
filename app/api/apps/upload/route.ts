import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { currentSession } from '@/lib/session';
import { saveUpload, uploadKey, iconKey } from '@/lib/storage';

export const runtime = 'nodejs';
export const maxDuration = 300;

function slugify(value: string) {
  return value.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '');
}

export async function POST(request: Request) {
  try {
    const session = await currentSession();
    if (!session || !['DEVELOPER', 'ADMIN'].includes(session.role)) return NextResponse.json({ error: 'Apenas desenvolvedores podem publicar' }, { status: 403 });

    const form = await request.formData();
    const file = form.get('file');
    const icon = form.get('icon');
    const title = String(form.get('title') || '').trim();
    const description = String(form.get('description') || '').trim();
    const category = String(form.get('category') || '').trim();
    const version = String(form.get('version') || '').trim();

    if (!(file instanceof File) || !title || !description || !category || !version) return NextResponse.json({ error: 'Preencha todos os campos obrigatórios' }, { status: 400 });
    if (!/\.(apk|aab)$/i.test(file.name)) return NextResponse.json({ error: 'Envie um arquivo APK ou AAB' }, { status: 400 });
    if (file.size === 0 || file.size > 250 * 1024 * 1024) return NextResponse.json({ error: 'O arquivo deve ter entre 1 byte e 250 MB' }, { status: 400 });
    if (icon instanceof File && icon.size > 5 * 1024 * 1024) return NextResponse.json({ error: 'O ícone deve ter no máximo 5 MB' }, { status: 400 });

    const developer = await prisma.developer.upsert({ where: { userId: session.userId }, update: {}, create: { userId: session.userId } });
    const fileUrl = await saveUpload(file, uploadKey(session.userId, file.name));
    const iconUrl = icon instanceof File && icon.size > 0 ? await saveUpload(icon, iconKey(session.userId, icon.name)) : undefined;
    const app = await prisma.app.create({ data: { title, slug: `${slugify(title)}-${Date.now()}`, description, category, version, fileUrl, fileName: file.name, fileSize: file.size, iconUrl, ownerId: session.userId, developerId: developer.id } });
    return NextResponse.json({ app }, { status: 201 });
  } catch (error) {
    console.error('APP_UPLOAD_ERROR', error);
    return NextResponse.json({ error: error instanceof Error ? error.message : 'Erro ao publicar aplicativo' }, { status: 500 });
  }
}
