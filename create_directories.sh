#!/bin/bash

# Charger les variables d'environnement à partir du fichier .env
source .env

mkdir -p $DATA_PATH/torrents/{books,movies,music,tv}
mkdir -p $DATA_PATH/usenet/{incomplete,complete/{books,movies,music,tv}}
mkdir -p $DATA_PATH/media/{books,movies,music,tv}

# Monitoring (grafana and prometheus run as PUID:PGID)
mkdir -p $APPDATA_PATH/grafana $APPDATA_PATH/prometheus/data
