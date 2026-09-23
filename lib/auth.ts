import { SignJWT, jwtVerify } from 'jose';

export type Session = { userId: string; role: 'USER' | 'DEVELOPER' | 'ADMIN'; email: string };
const secret = new TextEncoder().encode(process.env.JWT_SECRET || 'development-only-secret');

export async function createSession(session: Session) {
  return new SignJWT(session).setProtectedHeader({ alg: 'HS256' }).setIssuedAt().setExpirationTime('7d').sign(secret);
}
export async function readSession(token: string): Promise<Session | null> {
  try { return (await jwtVerify(token, secret)).payload as unknown as Session; } catch { return null; }
}
