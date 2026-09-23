#!/usr/bin/env bash
set -Eeuo pipefail
: "${CREDIT_API_URL:?Defina CREDIT_API_URL}"
: "${APP_SLUG:?Defina APP_SLUG}"
: "${OUTPUT_FILE:?Defina OUTPUT_FILE}"
mkdir -p "$(dirname "$OUTPUT_FILE")"
curl --fail-with-body -L --output "$OUTPUT_FILE" "$CREDIT_API_URL/api/apps/$APP_SLUG/download"
echo "Download concluído: $OUTPUT_FILE"
