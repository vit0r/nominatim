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

gunicorn --access-logfile - \
    --error-logfile - \
    --capture-output \
    --log-level=debug \
    -b unix:/data/nominatim.sock \
    -w 4 -k uvicorn.workers.UvicornWorker "nominatim_api.server.falcon.server:run_wsgi()"