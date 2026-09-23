#!/usr/bin/env bash
set -Eeuo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ANDROID_PROJECT_DIR:-$ROOT_DIR}"
[ -f gradlew ] || { echo 'gradlew não encontrado; defina ANDROID_PROJECT_DIR'; exit 1; }
chmod +x gradlew
./gradlew clean bundleRelease assembleRelease
mkdir -p "$ROOT_DIR/dist/android"
find . -type f \( -name '*.aab' -o -name '*.apk' \) -path '*/release/*' -exec cp {} "$ROOT_DIR/dist/android/" \;
ls -lh "$ROOT_DIR/dist/android"
