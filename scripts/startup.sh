#!/bin/sh
sleep 5 && cd /organicity-discovery-api && bundle && bundle exec skylight setup lF4pTWJv0w3d && rake db:create db:migrate db:seed RAILS_ENV=production;
rm -f /organicity-discovery-api/tmp/pids/*.pid || true;
bundle exec puma -C config/puma.rb;
