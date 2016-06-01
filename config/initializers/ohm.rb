require "ohm"
Ohm.redis = Redic.new(Rails.application.secrets.redis_url)
