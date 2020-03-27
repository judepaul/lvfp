Rails.application.routes.draw do
  
  resources :listeners
  resources :access_codes
  resources :speeches
  resources :skills
  get 'dashboard/index'

  #devise_for :users
  devise_for :users, :controllers => {:sessions => 'sessions', :registrations => "registrations"}, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'signup' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  authenticated :user do
    root to: 'dashboard#index', as: :authenticated_root
  end
  root to: redirect('/auth/login')

  # Amazon comes in with a post request
  post '/skill/handler' => 'skills#root', :as => :skill_handler

  get "users/check_username", :controller => "registrations", :action => "check_username"

  get "speeches/published_details/:speech_id" => "speeches#published_details", as: "published_details"

end
