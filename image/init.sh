#!/bin/bash

if [ ! -f "$HOME/data/latest.osm.pbf" ]; then
    echo "init download $NOMINATIM_PBF"
    wget -c $NOMINATIM_PBF -O $HOME/data/latest.osm.pbf
    echo "end download $NOMINATIM_PBF"
    sleep 2
fi