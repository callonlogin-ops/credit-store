#!/usr/bin/env bash
set -Eeuo pipefail
: "${GOOGLE_PACKAGE_NAME:?Defina GOOGLE_PACKAGE_NAME}"
: "${GOOGLE_JSON_KEY:?Defina GOOGLE_JSON_KEY}"
: "${ANDROID_AAB:?Defina ANDROID_AAB}"
: "${GOOGLE_TRACK:=internal}"
command -v fastlane >/dev/null || { echo 'Instale: gem install fastlane'; exit 1; }
fastlane supply --package_name "$GOOGLE_PACKAGE_NAME" --json_key "$GOOGLE_JSON_KEY" --aab "$ANDROID_AAB" --track "$GOOGLE_TRACK" --skip_upload_metadata true --skip_upload_images true --skip_upload_screenshots true
