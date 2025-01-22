#!/bin/bash

if [ ! -d "$PGDATA" ]; then
    echo "init permissions postgres"
    chmod 777 -R /data
fi