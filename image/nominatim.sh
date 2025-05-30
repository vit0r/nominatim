#!/bin/bash
set -e
until [ "$(pg_isready -h $NOMINATIM_DATASE_HOST)" = "$NOMINATIM_DATASE_HOST:5432 - accepting connections" ]
do 
    echo "postgres $NOMINATIM_DATASE_HOST is not ready yet"
    sleep 2
done
DB_EXISTS=$(psql -h $NOMINATIM_DATASE_HOST -c "SELECT 1 as exists FROM pg_database WHERE datname='$POSTGRES_DB';")
if [ ! -f "/data/import.log" ] && [ $DB_EXISTS=="exists -------- 0" ]; then
    echo "import osm file"
    nominatim import --osm-file /data/latest.osm.pbf --verbose
    echo "$(date)" >> /data/import.log
fi
gunicorn --bind 0.0.0.0:8000 \
    --access-logfile - \
    --error-logfile - \
    --capture-output \
    --log-level=debug \
    -b unix:/data/nominatim.sock \
    -k uvicorn.workers.UvicornWorker "nominatim_api.server.falcon.server:run_wsgi()"