#!/usr/bin/env bash
set -Eeuo pipefail
: "${AMAZON_UPLOAD_URL:?Defina AMAZON_UPLOAD_URL conforme sua conta Amazon}"
: "${AMAZON_TOKEN:?Defina AMAZON_TOKEN}"
: "${ANDROID_APK:?Defina ANDROID_APK}"
curl --fail-with-body -L -X POST "$AMAZON_UPLOAD_URL" -H "Authorization: Bearer $AMAZON_TOKEN" --form "file=@$ANDROID_APK;type=application/vnd.android.package-archive" --form "package_name=${AMAZON_PACKAGE_NAME:-}" | tee amazon-upload-result.json
echo 'Upload Amazon enviado; acompanhe a revisão no portal.'
