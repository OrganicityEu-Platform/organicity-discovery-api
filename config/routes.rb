require 'sidekiq/web'
require 'sidetiq/web'

Rails.application.routes.draw do
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end
  mount Sidekiq::Web, at: "/sidekiq"

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
    scope '/assets/:id' do
      get '/' => 'assets#show', constraints: { id: /[a-zA-Z1-9\.\:]+/ }
      get '/ngsiv2' => 'assets#show_ngsiv2', constraints: { id: /[a-zA-Z1-9\.\:]+/ }
      get '/nearby' => 'assets#nearby', constraints: { id: /[a-zA-Z1-9\.\:]+/ }
      get '/data' => 'assets#data', constraints: { id: /[a-zA-Z1-9\.\:]+/ }
      get '/data/ngsiv2' => 'assets#show_ngsiv2', constraints: { id: /[a-zA-Z1-9\.\:]+/ }
    end
    scope '/assets' do
      get '/' => 'assets#index'
    end
    resources :types
  end

  namespace :v2 do
    resources :assets
  end
end
