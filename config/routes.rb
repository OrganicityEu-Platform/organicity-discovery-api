Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v0 do
      scope '/assets/sites' do
        get ':site' => 'assets#site'
      end
      scope '/assets/geo/search' do
        get '/' => 'assets#geo'
      end
      scope '/assets/services' do
        get ':service' => 'assets#service'
      end
      resources :assets
    end
  end
end
