Rails.application.routes.draw do
  
  resources :speeches
  resources :skills
  get 'dashboard/index'

  #devise_for :users
  devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'signup' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'dashboard#index'

  # Amazon comes in with a post request
  post '/skill/handler' => 'skills#root', :as => :skill_handler

end
