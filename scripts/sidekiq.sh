#!/bin/sh
bundle exec skylight setup $SKYLIGHT;
bundle exec sidekiq -e $RAILS_ENV -c 25 -C config/sidekiq.yml;
