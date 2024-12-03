#!/bin/bash

set -a && source .env && set +a

PROWLARR_API_KEY="be3bd470054a415fbe8dc0e97b5ce1ac"

# Sharewood Indexer
curl -X POST "http://prowlarr.lan/api/v1/indexer" \
-H "X-Api-Key: ${PROWLARR_API_KEY}" \
-H "Content-Type: application/json" \
-d '{
  "name": "Sharewood",
  "enable": true,
  "protocol": "usenet",
  "implementationName": "Sharewood",
  "implementation": "Sharewood",
  "configContract": "SharewoodSettings",
  "fields": [
    {
        "name": "baseUrl",
        "value": "https://api.sharewood.com"
    },
    {
        "name": "apiKey",
        "value": "4c8ad0b1ab0ab979064bb474cf0e55b9"
    }
  ]
}'
