#!/usr/bin/env bash
set -Eeuo pipefail
: "${CREDIT_API_URL:?Defina CREDIT_API_URL}"
: "${CREDIT_SESSION:?Defina CREDIT_SESSION}"
: "${APP_TITLE:?Defina APP_TITLE}"
: "${APP_DESCRIPTION:?Defina APP_DESCRIPTION}"
: "${APP_CATEGORY:?Defina APP_CATEGORY}"
: "${APP_VERSION:?Defina APP_VERSION}"
: "${APK_FILE:?Defina APK_FILE ou AAB_FILE}"
[ -f "$APK_FILE" ] || { echo "Arquivo não encontrado: $APK_FILE" >&2; exit 1; }
case "$APK_FILE" in *.apk|*.aab) ;; *) echo 'Use .apk ou .aab'; exit 1;; esac
curl --fail-with-body -L -X POST "$CREDIT_API_URL/api/apps/upload" --cookie "credit_session=$CREDIT_SESSION" --form "title=$APP_TITLE" --form "description=$APP_DESCRIPTION" --form "category=$APP_CATEGORY" --form "version=$APP_VERSION" --form "file=@$APK_FILE;type=application/octet-stream" | tee upload-result.json
echo 'Upload concluído.'
