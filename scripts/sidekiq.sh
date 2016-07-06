#!/bin/sh
bundle exec sidekiq -e $RAILS_ENV -c 25 -C config/sidekiq.yml;
