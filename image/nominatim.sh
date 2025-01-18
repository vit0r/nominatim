#!/bin/bash

until [ "$(pg_isready -h 127.0.0.1)" = "127.0.0.1:5432 - accepting connections" ]
do 
    echo "postgres is not ready yet"
    sleep 5
done

if [ ! -f "/data/import.log" ]; then
    dropdb -h localhost nominatim -f
    echo "import osm file"
    nominatim import --osm-file /data/latest.osm.pbf --all
    echo "$(date)" >> /data/import.log
fi
# nominatim admin --check-database
nominatim serve --engine starlette