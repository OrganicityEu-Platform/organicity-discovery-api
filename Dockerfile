FROM ruby:2.4.2

# Install essential Linux packages
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    postgresql-client \
    nodejs

WORKDIR /organicity-discovery-api/

# Copy Gemfile and Gemfile.lock
COPY Gemfile* /organicity-discovery-api/

# Speed up nokogiri install
ENV NOKOGIRI_USE_SYSTEM_LIBRARIES 1

RUN bundle install

# Copy the Rails application into place
COPY . /organicity-discovery-api/

# Define the script we want run once the container boots
# Use the "exec" form of CMD so our script shuts down gracefully on SIGTERM (i.e. `docker stop`)
# CMD [ "scripts/sidekiq.sh" ]
