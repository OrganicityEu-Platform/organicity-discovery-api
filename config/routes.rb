require 'sidekiq/web'
require 'sidetiq/web'

Rails.application.routes.draw do
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end
  mount Sidekiq::Web, at: "/sidekiq"

  namespace :v0 do
    scope '/assets/sites' do
      get '/' => 'sites#index'
      get ':site' => 'assets#site'
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
    scope '/assets/services' do
      get ':service' => 'assets#service'
    end
    scope '/assets/providers' do
      get ':service' => 'assets#provider'
    end
    resources :assets
    scope '/assets/:id' do
      get '/' => 'assets#show'
    end
    scope '/assets/:id/data' do
      get '/' => 'assets#data'
    end
    scope '/assets/:id/nearby' do
      get '/' => 'assets#nearby'
    end
    scope '/assets/:id/v2' do
      get '/' => 'assets#v2'
    end
  end

  namespace :v2 do
    resources :assets
  end
end
