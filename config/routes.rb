Rails.application.routes.draw do
  namespace :v0 do
    scope '/assets/sites' do
      get '/' => 'sites#index'
      get ':site' => 'assets#site'
    end
    scope '/assets/geo/search' do
      get '/' => 'assets#geo'
    end
    scope '/assets/services' do
      get ':service' => 'assets#service'
    end
    scope '/assets/providers' do
      get ':service' => 'assets#provider'
    end
    scope '/assets/ligthweight' do
      get '/' => 'assets#ligthweight'
    end
    resources :assets
  end
end
