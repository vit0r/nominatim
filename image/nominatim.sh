#!/bin/bash

until [ "$(pg_isready -h 127.0.0.1)" = "127.0.0.1:5432 - accepting connections" ]
do 
    echo "postgres is not ready yet"
    sleep 5
done
if [ ! -f "/data/import.log" ]; then
    echo "iniciar import"
    nominatim import --osm-file /data/latest.osm.pbf --verbose
    nominatim import --continue indexing --index-noanalyse --verbose
    nominatim admin --check-database
    echo "import ok $(date)" > /data/import.log
fi
echo > /data/api-access.log
echo > /data/api-error.log
gunicorn --bind 0.0.0.0:8000 --access-logfile /data/api-access.log --error-logfile /data/api-error.log -b unix:/data/nominatim.sock -k uvicorn.workers.UvicornWorker nominatim_api.server.falcon.server:run_wsgi
tail -f /data/api-access.log