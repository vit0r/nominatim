#!/bin/bash

NOMINATIM_TAG=4.5.0
docker build -t vit0r/nominatim:${NOMINATIM_TAG} --target nominatim ./image
docker build -t vit0r/nominatim-init:${NOMINATIM_TAG} --target nominatim-init ./image
docker build -t vit0r/postgres:${NOMINATIM_TAG} --target postgres ./image
docker push vit0r/nominatim:${NOMINATIM_TAG}
docker push vit0r/nominatim-init:${NOMINATIM_TAG}
docker push vit0r/postgres:${NOMINATIM_TAG}