#!/bin/bash

set -a && source .env && set +a

SONARR_API_KEY="832d8dbcaa994a1d97082cb17d4b7b98"

# qBittorrent
curl -X POST "http://sonarr.lan/api/v3/downloadclient" \
-H "X-Api-Key: ${SONARR_API_KEY}" \
-H "Content-Type: application/json" \
-d '{
  "name": "qBittorrent",
  "enable": true,
  "implementation": "QBittorrent",
  "configContract": "QBittorrentSettings",
  "fields": [
    {
        "label": "Host",
        "name": "host",
        "type": "string",
        "value": "qbittorrent"
    },
    {
        "label": "Username",
        "name": "username",
        "type": "string",
        "value": "admin"
    },
    {
        "label": "Password",
        "name": "password",
        "type": "string",
        "value": "adminadmin"
    },
  ]
}'

# rFlood
curl -X POST "http://sonarr.lan/api/v3/downloadclient" \
-H "X-Api-Key: ${SONARR_API_KEY}" \
-H "Content-Type: application/json" \
-d '{
  "name": "Flood",
  "enable": true,
  "implementation": "Flood",
  "configContract": "FloodSettings",
  "fields": [
    {
        "label": "Host",
        "name": "host",
        "type": "string",
        "value": "rflood"
    },
    {
        "label": "Username",
        "name": "username",
        "type": "string",
        "value": "admin"
    },
    {
        "label": "Password",
        "name": "password",
        "type": "string",
        "value": "adminadmin"
    },
  ]
}'