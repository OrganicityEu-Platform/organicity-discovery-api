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
    scope '/assets/geo' do
      get '/' => 'assets#geo'
      get '/search' => 'assets#geo_search'
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
    end
  end
end
