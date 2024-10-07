#!/bin/bash

until [ "$(pg_isready -h localhost)" = "localhost:5432 - accepting connections" ]
do 
    echo "postgres is not ready"
    sleep 2
done
if [ ! -f "/data/import_ok" ]; then
    echo "drop database nominatim"
    dropdb nominatim -h localhost
    nominatim import --osm-file /data/latest.osm.pbf
    nominatim reverse -h
    echo "imported date: $date" > /data/import_ok
else
    nominatim admin --check-database
fi
gunicorn -b unix:/data/nominatim.sock -w 4 -k uvicorn.workers.UvicornWorker nominatim_api.server.falcon.server:run_wsgi
