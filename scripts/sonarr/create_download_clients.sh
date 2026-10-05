#!/bin/bash

set -a && source .env && set +a

: "${SONARR_API_KEY:?SONARR_API_KEY must be set in .env}"
: "${DOWNLOAD_CLIENT_USERNAME:?DOWNLOAD_CLIENT_USERNAME must be set in .env}"
: "${DOWNLOAD_CLIENT_PASSWORD:?DOWNLOAD_CLIENT_PASSWORD must be set in .env}"

# qBittorrent
curl -X POST "http://sonarr.lan/api/v3/downloadclient" \
-H "X-Api-Key: ${SONARR_API_KEY}" \
-H "Content-Type: application/json" \
-d "{
  \"name\": \"qBittorrent\",
  \"enable\": true,
  \"implementation\": \"QBittorrent\",
  \"configContract\": \"QBittorrentSettings\",
  \"fields\": [
    {
        \"label\": \"Host\",
        \"name\": \"host\",
        \"type\": \"string\",
        \"value\": \"qbittorrent\"
    },
    {
        \"label\": \"Username\",
        \"name\": \"username\",
        \"type\": \"string\",
        \"value\": \"${DOWNLOAD_CLIENT_USERNAME}\"
    },
    {
        \"label\": \"Password\",
        \"name\": \"password\",
        \"type\": \"string\",
        \"value\": \"${DOWNLOAD_CLIENT_PASSWORD}\"
    }
  ]
}"

# rFlood
curl -X POST "http://sonarr.lan/api/v3/downloadclient" \
-H "X-Api-Key: ${SONARR_API_KEY}" \
-H "Content-Type: application/json" \
-d "{
  \"name\": \"Flood\",
  \"enable\": true,
  \"implementation\": \"Flood\",
  \"configContract\": \"FloodSettings\",
  \"fields\": [
    {
        \"label\": \"Host\",
        \"name\": \"host\",
        \"type\": \"string\",
        \"value\": \"rflood\"
    },
    {
        \"label\": \"Username\",
        \"name\": \"username\",
        \"type\": \"string\",
        \"value\": \"${DOWNLOAD_CLIENT_USERNAME}\"
    },
    {
        \"label\": \"Password\",
        \"name\": \"password\",
        \"type\": \"string\",
        \"value\": \"${DOWNLOAD_CLIENT_PASSWORD}\"
    }
  ]
}"
