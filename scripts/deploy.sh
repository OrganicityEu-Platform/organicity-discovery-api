#!/bin/sh
ssh deployer@139.162.164.206 "cd organicity-discovery-api; git pull origin master; docker-compose build && docker-compose stop && docker-compose up -d; exit"
