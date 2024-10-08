#!/bin/bash

POSTGRES_TAG=13
NOMINATIM_TAG=4.5.0
docker build -t vit0r/nominatim:${NOMINATIM_TAG} --target nominatim .
docker build -t vit0r/nominatim-init:${NOMINATIM_TAG} --target nominatim-init .
docker build -t vit0r/postgres:${POSTGRES_TAG} --target postgres .
docker push vit0r/nominatim:${NOMINATIM_TAG}
docker push vit0r/nominatim-init:${NOMINATIM_TAG}
docker push vit0r/postgres:${POSTGRES_TAG}