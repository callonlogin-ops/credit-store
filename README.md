# Credit Store

MVP de uma loja de aplicativos Android para publicação e distribuição de APKs.

## Stack

- Next.js 14 + TypeScript
- Tailwind CSS
- Prisma + PostgreSQL
- JWT em cookie HttpOnly
- Armazenamento compatível com S3/R2

## Executar localmente

```bash
cp .env.example .env.local
npm install
npx prisma generate
npx prisma migrate dev --name init
npm run dev
```

Abra http://localhost:3000.

## Variáveis de ambiente

Preencha `DATABASE_URL`, `JWT_SECRET` e as credenciais do armazenamento S3/R2. Para desenvolvimento, o upload exige armazenamento configurado; a listagem e autenticação usam PostgreSQL.

## Rotas principais

- `POST /api/auth/register`
- `POST /api/auth/login`
- `POST /api/auth/logout`
- `GET /api/auth/me`
- `GET /api/apps`
- `POST /api/apps`
- `GET /api/apps/:slug`
- `POST /api/apps/:slug/download`
- `GET /api/developer/apps`

Aplicativos novos entram como `PENDING` e precisam ser aprovados por um administrador antes de aparecerem publicamente.
