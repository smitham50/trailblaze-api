Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post '/signup' => 'users#create'
      patch '/update_account' => 'users#update'
      delete '/cancel_account' => 'users#destroy'
      
      post '/my_hikes/add_hike' => 'user_hikes#add_trail_to_hikes'
      delete '/my_hikes/delete_hike/:trail_id' => 'user_hikes#destroy'
      get '/my_hikes' => 'user_hikes#get_my_hikes'

      post '/login' => 'sessions#create'
      post '/logout' => 'sessions#destroy'
      get '/logged_in' => 'sessions#is_logged_in?'

      get '/trails/:slug' => 'trails#get_trail'
      post '/trails/search' => 'trails#search_trails'
      post '/trails/associate_trails' => 'trails#associate_trails'
      
      post '/search_reload' => 'trails#search_reload'

      get '/map_auth' => 'maps#get_key'
    end
  end
end
