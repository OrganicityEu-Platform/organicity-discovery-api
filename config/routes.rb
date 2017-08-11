require 'sidekiq/web'
require 'sidetiq/web'

Rails.application.routes.draw do
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end
  mount Sidekiq::Web, at: "/sidekiq"

  post '/:provider',      to: 'auth#authenticate'

  get '/', to: 'info#index'

  constraints(id: /[^\/]+/) do # Allows the asset id / urn to contain dots and other special characters
    namespace :v0 do
      scope '/assets/ngsiv2' do
        get '/' => 'assets#ngsiv2'
      end
      scope '/assets/sites' do
        get '/' => 'sites#index'
        get ':site' => 'assets#site'
        get ':site/geo' => 'assets#site_geojson'
      end
      scope '/assets/experiments' do
        get ':experiment' => 'assets#experiment'
      end
      scope '/assets/experimenters' do
        get ':experimenter' => 'assets#experimenter'
      end
      scope '/assets/geo' do
        get '/' => 'assets#geo'
        get '/search' => 'assets#geo_search'
        get '/zoom/:zoom' => 'assets#geo_count'
      end
      scope '/assets/metadata' do
        get '/search' => 'assets#metadata_search'
      end
      scope '/assets/services' do
        get ':service' => 'assets#service'
      end
      scope '/assets/providers' do
        get ':service' => 'assets#provider'
      end
      resources :assets
      scope '/assets/:id/data' do
        get '/' => 'assets#data'
        get '/ngsiv2' => 'assets#show_ngsiv2'
      end
      scope '/assets/:id/nearby' do
        get '/' => 'assets#nearby'
      end
      scope '/assets/:id/ngsiv2' do
        get '/' => 'assets#show_ngsiv2'
      end
      resources :types
    end

    namespace :v2 do
      resources :assets
    end
  end
end
