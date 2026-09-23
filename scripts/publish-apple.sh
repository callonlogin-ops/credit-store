#!/usr/bin/env bash
set -Eeuo pipefail
: "${IOS_IPA:?Defina IOS_IPA}"
: "${APPLE_APP_IDENTIFIER:?Defina APPLE_APP_IDENTIFIER}"
: "${APPLE_API_KEY_JSON:?Defina APPLE_API_KEY_JSON}"
: "${APPLE_TEAM_ID:?Defina APPLE_TEAM_ID}"
command -v fastlane >/dev/null || { echo 'Instale: gem install fastlane'; exit 1; }
fastlane pilot upload --ipa "$IOS_IPA" --app_identifier "$APPLE_APP_IDENTIFIER" --team_id "$APPLE_TEAM_ID" --api_key_path "$APPLE_API_KEY_JSON" --skip_waiting_for_build_processing true
