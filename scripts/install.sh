#!/usr/bin/env bash
set -Eeuo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
command -v node >/dev/null || { echo 'Node.js 18+ obrigatório'; exit 1; }
command -v npm >/dev/null || { echo 'npm obrigatório'; exit 1; }
command -v git >/dev/null || { echo 'git obrigatório'; exit 1; }
command -v curl >/dev/null || { echo 'curl obrigatório'; exit 1; }
if command -v pkg >/dev/null 2>&1; then pkg update -y; pkg install -y nodejs-lts npm git curl jq openssl nano; fi
[ -f .env.local ] || cp .env.example .env.local
npm install
npx prisma generate
if [ "${RUN_MIGRATIONS:-0}" = 1 ]; then npx prisma migrate deploy; fi
chmod +x scripts/*.sh
echo 'Instalação concluída. Configure: nano .env.local'
echo 'Execute: npm run dev'
