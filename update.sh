#!/bin/bash

#https://nominatim.org/release-docs/develop/admin/Update/

echo "init update $NOMINATIM_REPLICATION_URL"
nominatim replication --init
nominatim replication --once
nominatim refresh --postcodes