# Base image with ruby 2.2.2
FROM ruby:2.2.2

MAINTAINER Silvia Puglisi <silvia@fablabbcn.org>

WORKDIR /$APPROOT
ENV APPROOT organicity-discovery-api

# Install essential Linux packages
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client && apt-get install -y nodejs

# Update Gems
RUN gem update --system

# Setup ssh key so that tunnel Works
RUN mkdir /root/.ssh
ADD ssh/* /root/.ssh/
RUN cp /root/.ssh/gcocd /root/.ssh/id_rsa &&\
    ls /root/.ssh/  &&\
    ls &&\
    chmod 700 /root/.ssh &&\
    chmod 600 /root/.ssh/* &&\
    chmod 644 ~/.ssh/ssh_config &&\
    ssh-keyscan -t rsa ec2-52-40-19-99.us-west-2.compute.amazonaws.com >> /root/.ssh/known_hosts


# Clone our private GitHub Repository
RUN git clone -b master https://github.com/OrganicityEu/organicity-discovery-api.git /$APPROOT

# Define where our application will live inside the image
ENV RAILS_ROOT $APPROOT

# Create application home. App server will need the pids dir so just create everything in one shot
RUN mkdir -p $APPROOT/tmp/pids

# Set our working directory inside the image
WORKDIR $RAILS_ROOT

# Prevent bundler warnings; ensure that the bundler version executed is >= that which created Gemfile.lock
RUN gem install bundler

# Finish establishing our Ruby environment
RUN gem install nokogiri
COPY Gemfile Gemfile
RUN bundle install

# Copy the Rails application into place
COPY . .

# Define the script we want run once the container boots
# Use the "exec" form of CMD so our script shuts down gracefully on SIGTERM (i.e. `docker stop`)
# CMD [ "scripts/app_cmd.sh" ]
