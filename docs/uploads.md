# Instalação local

```bash
chmod +x scripts/install.sh
./scripts/install.sh
```

O script sincroniza dependências, gera o cliente Prisma e valida o build. Configure `.env.local` antes de publicar.

## Upload e download

1. Crie um bucket S3 ou Cloudflare R2.
2. Configure `S3_ENDPOINT`, `S3_ACCESS_KEY_ID`, `S3_SECRET_ACCESS_KEY`, `S3_BUCKET` e `S3_PUBLIC_URL`.
3. Crie uma conta de desenvolvedor em `/register`.
4. Envie APK/AAB em `/dashboard/upload`.
5. O app ficará `PENDING` até aprovação administrativa.
6. Depois de aprovado, o botão de download chama `/api/apps/:slug/download`, registra o download e redireciona para o arquivo.

O bucket precisa permitir leitura pública dos objetos ou usar um domínio público/CDN em `S3_PUBLIC_URL`. Nunca coloque chaves secretas no frontend.

Para executar migrações já criadas:

```bash
RUN_MIGRATIONS=1 ./scripts/install.sh
```
