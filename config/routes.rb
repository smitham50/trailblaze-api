Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post '/signup' => 'users#create'
      
      post '/my_hikes/add_hike' => 'user_hikes#add_trail_to_hikes'
      get '/my_hikes/:user_id' => 'user_hikes#get_my_hikes'

      post '/login' => 'sessions#create'
      post '/logout' => 'sessions#destroy'
      get '/logged_in' => 'sessions#is_logged_in?'

      get '/trails/:slug' => 'trails#get_trail'
      post '/trails' => 'trails#get_trails'
      post '/search_reload' => 'trails#search_reload'
      
    end
  end
end
