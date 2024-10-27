#!/bin/bash

until [ "$(pg_isready -h 127.0.0.1)" = "127.0.0.1:5432 - accepting connections" ]
do 
    echo "postgres is not ready"
    sleep 2
done
if [ ! -f "/data/importok" ]; then
    dropdb -h 127.0.0.1 nominatim;
    nominatim import --osm-file /data/latest.osm.pbf --verbose
fi
nominatim admin --check-database
gunicorn --bind 0.0.0.0:8000 --log-level debug --log-file /data/nominatimapi.log -b unix:/data/nominatim.sock -k uvicorn.workers.UvicornWorker nominatim_api.server.falcon.server:run_wsgi