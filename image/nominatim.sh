#!/bin/bash

until [ "$(pg_isready -h 127.0.0.1)" = "127.0.0.1:5432 - accepting connections" ]
do 
    echo "postgres is not ready yet"
    sleep 5
done
if [ ! -f "/data/import.log" ]; then
    echo "iniciar import"
    nominatim import --osm-file /data/latest.osm.pbf --verbose
    nominatim import --continue indexing --verbose
    echo "imported $(date)" > /data/import.log
fi
gunicorn --bind 0.0.0.0:8000 --access-logfile - --error-logfile - --capture-output -b unix:/data/nominatim.sock -k uvicorn.workers.UvicornWorker nominatim_api.server.falcon.server:run_wsgi