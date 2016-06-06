#!/bin/sh
sleep 5 && cd /organicity-discovery-api && rake db:create db:migrate db:seed RAILS_ENV=development;
rm -f /organicity-discovery-api/tmp/pids/*.pid || true;
bundle exec puma -C config/puma.rb;
