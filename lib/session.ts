import { cookies } from 'next/headers';
import { prisma } from './prisma';
import { readSession, Session } from './auth';

export async function currentSession(): Promise<Session | null> {
  const token = cookies().get('credit_session')?.value;
  return token ? readSession(token) : null;
}
export async function requireUser() {
  const session = await currentSession();
  if (!session) throw new Error('UNAUTHORIZED');
  const user = await prisma.user.findUnique({ where: { id: session.userId } });
  if (!user) throw new Error('UNAUTHORIZED');
  return user;
}
