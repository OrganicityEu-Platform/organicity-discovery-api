require "ohm"
uri = URI.parse(Rails.application.secrets.redis_url)
Ohm.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
