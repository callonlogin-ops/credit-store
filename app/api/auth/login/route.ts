import { NextResponse } from 'next/server';
import bcrypt from 'bcryptjs';
import { z } from 'zod';
import { prisma } from '@/lib/prisma';
import { createSession } from '@/lib/auth';

export async function POST(request: Request) {
  const input = z.object({ email: z.string().email(), password: z.string().min(1) }).safeParse(await request.json());
  if (!input.success) return NextResponse.json({ error: 'E-mail e senha são obrigatórios' }, { status: 400 });
  const user = await prisma.user.findUnique({ where: { email: input.data.email.toLowerCase() } });
  if (!user || !(await bcrypt.compare(input.data.password, user.passwordHash))) return NextResponse.json({ error: 'Credenciais inválidas' }, { status: 401 });
  const token = await createSession({ userId: user.id, email: user.email, role: user.role });
  const response = NextResponse.json({ user: { id: user.id, name: user.name, email: user.email, role: user.role } });
  response.cookies.set('credit_session', token, { httpOnly: true, sameSite: 'lax', secure: process.env.NODE_ENV === 'production', maxAge: 60 * 60 * 24 * 7, path: '/' });
  return response;
}
