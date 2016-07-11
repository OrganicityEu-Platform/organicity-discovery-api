#!/bin/sh
git fetch --all;
git reset --hard origin/master;
docker-compose stop && docker-compose build && docker-compose up -d && ./scripts/clean.sh;
