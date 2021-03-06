source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "http://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.5'

# Use Postgres and ActiveRecord Postgis-adapter
gem 'pg'
gem 'activerecord-postgis-adapter', '=4.0.2'#, github: 'rgeo/activerecord-postgis-adapter'
gem 'rgeo'

# Use Puma as the app server
gem 'puma'

# Use Redis
gem 'redis', '>= 3.3.3'
gem 'redis-rack', github: 'redis-store/redis-rack', branch: 'master'
gem 'redis-rack-cache', github: 'redis-store/redis-rack-cache', branch: 'master'
gem 'redis-activesupport', github: 'redis-store/redis-activesupport', branch: 'master'
gem 'redis-actionpack', github: 'redis-store/redis-actionpack', branch: 'master'
gem 'redis-rails', github: 'redis-store/redis-rails', branch: 'master'

# Caching external API requests w/ semi-persistent objects
gem 'ohm'
gem 'rack-cache'

# Connecting to MongoDB
gem 'mongo', '< 2' # Syntax changes in 2.0
gem 'bson_ext'

# GeoJSON
gem 'rgeo-geojson'

# Use JWT for parsing tokens
gem 'jwt'

# Use http gem for http requests (some libs still use net/http)
gem 'http'

# Sidekiq for async jobs
gem 'sinatra', github: 'sinatra', :require => false
gem 'mustermann'
gem 'mustermann-contrib'
gem 'sidekiq'
gem 'sidetiq'

# For complex time parsings
gem 'chronic'

# Report errors to sentry.io
gem 'sentry-raven'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', :require => 'rack/cors'

gem 'active_model_serializers', github: 'rails-api/active_model_serializers', tag: 'v0.10.2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
	# For monitoring
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
