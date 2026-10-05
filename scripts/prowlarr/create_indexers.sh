#!/bin/bash

# Check for dependencies
if ! command -v jq &> /dev/null; then
  echo "jq could not be found, please install it"
  exit 1
fi

set -a && source .env && set +a

: "${PROWLARR_API_KEY:?PROWLARR_API_KEY must be set in .env}"
: "${PASSKEY_SHAREWOOD:?PASSKEY_SHAREWOOD must be set in .env}"

# Sharewood Indexer
jq --arg passkey "$PASSKEY_SHAREWOOD" '
  .fields |= map(
    if .name == "passkey" then
      .value = $passkey
    else
      .
    end
)' "${SCRIPTS_PATH}/prowlarr/indexers/sharewood.json" | \
curl -X POST "http://prowlarr.lan/api/v1/indexer" \
-H "X-Api-Key: ${PROWLARR_API_KEY}" \
-H "Content-Type: application/json" \
-d @-

# 1337x Indexer
curl -X POST "http://prowlarr.lan/api/v1/indexer" \
-H "X-Api-Key: ${PROWLARR_API_KEY}" \
-H "Content-Type: application/json" \
-d @${SCRIPTS_PATH}/prowlarr/indexers/1337x.json
