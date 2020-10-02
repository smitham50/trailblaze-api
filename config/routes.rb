Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post '/signup' => 'users#create'
      post '/login' => 'sessions#create'
      post '/logout' => 'sessions#destroy'

      patch '/update_address' => 'users#update'
    end
  end
end
