#!/bin/sh
git fetch --all;
git reset --hard origin/master;
docker-compose build && docker-compose up -d && ./scripts/clean.sh
