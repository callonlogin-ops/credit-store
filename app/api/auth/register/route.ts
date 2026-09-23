import { NextResponse } from 'next/server';
import bcrypt from 'bcryptjs';
import { z } from 'zod';
import { prisma } from '@/lib/prisma';
import { createSession } from '@/lib/auth';

const schema = z.object({ name: z.string().min(2), email: z.string().email(), password: z.string().min(8), developer: z.boolean().optional() });
export async function POST(request: Request) {
  try {
    const input = schema.parse(await request.json());
    const email = input.email.trim().toLowerCase();
    if (await prisma.user.findUnique({ where: { email } })) return NextResponse.json({ error: 'E-mail já cadastrado' }, { status: 409 });
    const role = input.developer ? 'DEVELOPER' : 'USER';
    const user = await prisma.user.create({ data: { name: input.name.trim(), email, passwordHash: await bcrypt.hash(input.password, 12), role, ...(input.developer ? { developer: { create: { companyName: input.name.trim() } } } : {}) } });
    const token = await createSession({ userId: user.id, email: user.email, role });
    const response = NextResponse.json({ user: { id: user.id, name: user.name, email: user.email, role } }, { status: 201 });
    response.cookies.set('credit_session', token, { httpOnly: true, sameSite: 'lax', secure: process.env.NODE_ENV === 'production', maxAge: 60 * 60 * 24 * 7, path: '/' });
    return response;
  } catch (error) { return NextResponse.json({ error: error instanceof z.ZodError ? 'Dados inválidos' : 'Erro ao cadastrar' }, { status: 400 }); }
}
