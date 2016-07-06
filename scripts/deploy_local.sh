#!/bin/sh
docker-compose stop && docker-compose build && docker-compose up -d && ./scripts/clean.sh;
# wget -N http://api.discovery.organicity.eu/v0/assets/geo.geojson && geojsonhint geo.geojson;
# rm geo.geojson;
