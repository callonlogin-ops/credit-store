import './globals.css';
import type { Metadata } from 'next';
export const metadata: Metadata = { title: 'Credit Store', description: 'Loja de aplicativos Android' };
export default function RootLayout({ children }: { children: React.ReactNode }) { return <html lang="pt-BR"><body>{children}</body></html>; }
