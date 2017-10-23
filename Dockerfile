# Base image with ruby 2.2.2
FROM ruby:2.4.2

# Install essential Linux packages
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    postgresql-client \
    nodejs

# Setup ssh key so that tunnel Works
RUN mkdir /root/.ssh
COPY /config/ssh/mongo_ssh_key /root/.ssh/gcocd
COPY /config/ssh/mongo_ssh_config /root/.ssh/ssh_config
RUN cp /root/.ssh/gcocd /root/.ssh/id_rsa &&\
    ls /root/.ssh/  &&\
    ls &&\
    chmod 700 /root/.ssh &&\
    chmod 600 /root/.ssh/* &&\
    chmod 644 /root/.ssh/ssh_config &&\
    ssh-keyscan -t rsa dev.orion.organicity.eu >> /root/.ssh/known_hosts # This fails. Must check.

# Clone our private GitHub Repository - should we? It will be COPY-ed below
#RUN git clone -b master https://github.com/OrganicityEu/organicity-discovery-api.git

ENV APPROOT /organicity-discovery-api
WORKDIR $APPROOT

# Create application home. App server will need the pids dir so just create everything in one shot
RUN mkdir -p $APPROOT/tmp/pids

# Update Gems
RUN gem update --system

# Prevent bundler warnings; ensure that the bundler version executed is >= that which created Gemfile.lock
RUN gem install bundler

# Finish establishing our Ruby environment
ADD $APPROOT/Gemfile $APPROOT/Gemfile
ADD $APPROOT/Gemfile.lock $APPROOT/Gemfile.lock

# Speed up nokogiri install
ENV NOKOGIRI_USE_SYSTEM_LIBRARIES 1

RUN bundle install

# Copy the Rails application into place
COPY . $APPROOT

# Define the script we want run once the container boots
# Use the "exec" form of CMD so our script shuts down gracefully on SIGTERM (i.e. `docker stop`)
# CMD [ "scripts/sidekiq.sh" ]
