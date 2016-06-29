#!/bin/sh
docker-compose build && docker-compose up -d && ./scripts/clean.sh
