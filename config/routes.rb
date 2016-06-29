Rails.application.routes.draw do
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
