'use client';

import { useEffect, useState } from 'react';
import Header from '@/components/Header';

type AppDetails = { title: string; description: string; category: string; version: string; fileName: string; fileSize: number; downloads: number; iconUrl: string | null; developer?: { companyName: string | null } };

function size(bytes: number) { return `${(bytes / 1024 / 1024).toFixed(1)} MB`; }

export default function AppPage({ params }: { params: { slug: string } }) {
  const [app, setApp] = useState<AppDetails | null>(null);
  const [error, setError] = useState('');
  useEffect(() => { fetch(`/api/apps/${params.slug}`).then(async response => { const data = await response.json(); if (!response.ok) throw new Error(data.error); setApp(data.app); }).catch(error => setError(error.message)); }, [params.slug]);

  return <><Header /><main className="mx-auto max-w-4xl px-4 py-16">{error ? <p className="text-red-400">{error}</p> : !app ? <p className="text-slate-400">Carregando aplicativo...</p> : <div className="rounded-3xl border border-white/10 bg-slate-900 p-8"><div className="flex items-center gap-5"><div className="flex h-20 w-20 items-center justify-center rounded-2xl bg-brand text-4xl font-black text-white">{app.iconUrl ? <img src={app.iconUrl} alt="" className="h-full w-full rounded-2xl object-cover" /> : app.title[0]}</div><div><p className="text-sm uppercase tracking-widest text-brand">{app.category}</p><h1 className="mt-2 text-4xl font-black text-white">{app.title}</h1></div></div><p className="mt-8 text-lg leading-8 text-slate-300">{app.description}</p><div className="mt-6 grid gap-3 text-sm text-slate-400 sm:grid-cols-4"><span>Versão {app.version}</span><span>{app.fileName}</span><span>{size(app.fileSize)}</span><span>{app.downloads} downloads</span></div><a href={`/api/apps/${params.slug}/download`} className="mt-8 inline-block rounded-lg bg-brand px-6 py-3 font-semibold text-white hover:opacity-90">Baixar {app.fileName}</a></div>}</main></>;
}
