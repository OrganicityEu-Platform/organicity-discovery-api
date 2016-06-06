uri = URI.parse(Rails.application.secrets.redis_url || ENV['REDIS_URL'])
$redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
