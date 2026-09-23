#!/usr/bin/env bash
set -Eeuo pipefail

# Credit Store - instalador, sincronizador e iniciador em um único arquivo.
# Uso: ./Index.sh [install|sync|start|build|migrate|all]

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

info() { printf '\033[1;34m[credit]\033[0m %s\n' "$*"; }
ok() { printf '\033[1;32m[ok]\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31m[erro]\033[0m %s\n' "$*" >&2; exit 1; }

check_tools() {
  command -v node >/dev/null 2>&1 || fail 'Node.js 18+ não encontrado.'
  command -v npm >/dev/null 2>&1 || fail 'npm não encontrado.'
  command -v git >/dev/null 2>&1 || fail 'git não encontrado.'
  local major
  major="$(node -p "process.versions.node.split('.')[0]")"
  [ "$major" -ge 18 ] || fail "Node.js 18+ é obrigatório; encontrado: $(node --version)"
}

install_termux_packages() {
  if command -v pkg >/dev/null 2>&1; then
    info 'Termux detectado; instalando dependências do sistema.'
    pkg update -y
    pkg install -y nodejs-lts npm git curl jq openssl nano
  fi
}

sync_project() {
  check_tools
  [ -f package.json ] || fail 'package.json não encontrado. Execute este arquivo na raiz do projeto.'
  info 'Instalando dependências npm.'
  npm install
  info 'Gerando cliente Prisma.'
  npx prisma generate
  chmod +x scripts/*.sh 2>/dev/null || true
  ok 'Projeto sincronizado.'
}

configure_env() {
  if [ ! -f .env.local ]; then
    cp .env.example .env.local
    ok '.env.local criado a partir de .env.example.'
  else
    info '.env.local já existe; não será sobrescrito.'
  fi
  if [ "${EDIT_ENV:-0}" = '1' ] && command -v nano >/dev/null 2>&1; then
    nano .env.local
  fi
}

migrate_db() {
  [ -f .env.local ] || configure_env
  info 'Executando migrações do Prisma.'
  npx prisma migrate dev --name init
  ok 'Banco sincronizado.'
}

build_project() {
  info 'Validando build de produção.'
  npm run build
  ok 'Build concluído.'
}

start_project() {
  info 'Iniciando Credit Store em http://localhost:3000'
  exec npm run dev
}

install_all() {
  install_termux_packages
  check_tools
  configure_env
  sync_project
  if [ "${RUN_MIGRATIONS:-0}" = '1' ]; then migrate_db; fi
}

usage() {
  cat <<'HELP'
Credit Store - comandos:

  ./Index.sh install   instala dependências, cria .env.local e gera Prisma
  ./Index.sh sync      sincroniza npm e Prisma
  ./Index.sh migrate   executa a migração do banco
  ./Index.sh build     gera o build de produção
  ./Index.sh start     inicia o servidor Next.js
  ./Index.sh all       instala, sincroniza, migra e inicia

Exemplos:
  ./Index.sh install
  EDIT_ENV=1 ./Index.sh install
  RUN_MIGRATIONS=1 ./Index.sh all
HELP
}

command="${1:-install}"
case "$command" in
  install) install_all ;;
  sync) sync_project ;;
  migrate) migrate_db ;;
  build) check_tools; build_project ;;
  start) check_tools; start_project ;;
  all) RUN_MIGRATIONS=1 install_all; migrate_db; start_project ;;
  -h|--help|help) usage ;;
  *) usage; fail "Comando desconhecido: $command" ;;
esac
