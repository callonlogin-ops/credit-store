#!/usr/bin/env bash
set -Eeuo pipefail

# Credit Store - ponto de entrada único e seguro.
# Não executa fastboot flash nem altera dispositivos.
# Uso: ./Start.sh [install|sync|migrate|build|start|all|play-console|help]

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

BLUE='\033[1;34m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; RESET='\033[0m'
info() { printf "${BLUE}[credit]${RESET} %s\n" "$*"; }
ok() { printf "${GREEN}[ok]${RESET} %s\n" "$*"; }
warn() { printf "${YELLOW}[aviso]${RESET} %s\n" "$*"; }

if [ ! -f "$ROOT_DIR/Index.sh" ]; then
  echo 'Index.sh não encontrado. Execute este script na raiz do repositório.' >&2
  exit 1
fi

install_dependencies() {
  if command -v pkg >/dev/null 2>&1; then
    info 'Termux detectado; instalando pacotes básicos.'
    pkg update -y
    pkg install -y nodejs-lts npm git curl jq openssl nano
  fi
  chmod +x "$ROOT_DIR/Index.sh" "$ROOT_DIR"/scripts/*.sh 2>/dev/null || true
  "$ROOT_DIR/Index.sh" install
}

open_play_console() {
  local url='https://play.google.com/console/u/0/signup'
  info "Google Play Console: $url"
  if command -v termux-open-url >/dev/null 2>&1; then termux-open-url "$url"
  elif command -v xdg-open >/dev/null 2>&1; then xdg-open "$url" >/dev/null 2>&1 || true
  fi
}

show_help() {
  cat <<'HELP'
Credit Store - comandos seguros

  ./Start.sh install        instala dependências e prepara .env.local
  ./Start.sh sync           sincroniza npm e Prisma
  ./Start.sh migrate        executa migração do banco
  ./Start.sh build          gera build de produção
  ./Start.sh start          inicia em http://localhost:3000
  ./Start.sh all            instala, migra e inicia
  ./Start.sh play-console   abre/informa o cadastro do Play Console
  ./Start.sh help           mostra esta ajuda

Observações:
- Windows10.iso deve ser tratado fora do projeto, com ferramenta oficial/Rufus/Ventoy.
- fastboot não é necessário para a loja e este script não executa `fastboot flash boot`.
- Nunca faça flash sem confirmar modelo, imagem, bootloader e backup do aparelho.
HELP
}

case "${1:-install}" in
  install) install_dependencies ;;
  sync|migrate|build|start|all) "$ROOT_DIR/Index.sh" "$1" ;;
  play-console) open_play_console ;;
  help|-h|--help) show_help ;;
  *) show_help; exit 2 ;;
esac
