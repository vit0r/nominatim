#!/bin/bash

until [ "$(pg_isready -h 127.0.0.1)" = "127.0.0.1:5432 - accepting connections" ]
do 
    echo "postgres is not ready yet"
    sleep 5
done
if psql -lqt | cut -d \| -f 1 | grep -qw "nominatim"; then
    echo "initialize nominatim update"
    nominatim replication --once
    nominatim refresh --postcodes
else
    echo "import osm file"
    nominatim import --osm-file $HOME/data/latest.osm.pbf --verbose
fi
gunicorn --bind 0.0.0.0:8000 --access-logfile - --error-logfile - --capture-output -b unix:$HOME/data/nominatim.sock -k uvicorn.workers.UvicornWorker nominatim_api.server.falcon.server:run_wsgi