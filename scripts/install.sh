#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

command -v node >/dev/null 2>&1 || { echo "Node.js 18+ é obrigatório." >&2; exit 1; }
command -v npm >/dev/null 2>&1 || { echo "npm é obrigatório." >&2; exit 1; }

if [ ! -f .env.local ]; then
  cp .env.example .env.local
  echo "Criado .env.local. Configure DATABASE_URL, JWT_SECRET e S3/R2 antes de iniciar."
fi

npm install
npx prisma generate

if [ "${RUN_MIGRATIONS:-0}" = "1" ]; then
  npx prisma migrate deploy
else
  echo "Migrações não executadas. Para executar em produção: RUN_MIGRATIONS=1 ./scripts/install.sh"
fi

npm run build
echo "Instalação concluída. Inicie com: npm run dev"
