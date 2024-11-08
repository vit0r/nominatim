#!/bin/bash

if [ ! -d "$PGDATA" ]; then
    echo "init permissions postgres"
    chmod 777 -R /postgres
fi

if [ ! -f "/data/latest.osm.pbf" ]; then
    chmod 777 -R /data
    echo "init download $NOMINATIM_PBF"
    wget -c $NOMINATIM_PBF -O /data/latest.osm.pbf
    echo "end download $NOMINATIM_PBF"
    sleep 2
    chmod 777 /data/latest.osm.pbf
fi