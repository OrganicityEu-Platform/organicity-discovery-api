#!/bin/sh
sleep 5 && cd /organicity-discovery-api && bundle && bundle exec skylight setup $SKYLIGHT && rake db:create db:migrate db:seed RAILS_ENV=$RAILS_ENV;
rm -f /organicity-discovery-api/tmp/pids/*.pid || true;
bundle exec puma -C config/puma.rb;
