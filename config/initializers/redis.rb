#By default, the client will try to read the REDIS_URL environment variable and use that as URL to connect to.
uri = URI.parse(Rails.application.secrets.redis_url || ENV['REDIS_URL'])
$redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
