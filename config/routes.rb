Rails.application.routes.draw do
  
  get 'users/edit'

  get 'users/update_password'

  get "/knowledge", to: "application#knowledge"
  get "/help", to: "application#help"
  get "/faq", to: "application#faq"
  get "/support", to: "application#support"
  get "/pricing", to: "application#pricing"
  get "/terms", to: "application#terms"
  get "/privacy", to: "application#privacy"
  get "/media", to: "application#media"

  
  resources :contacts
  #scope '/early-access' do
    resources :leads
  #end
  
  resources :listeners
  scope '/voice-reader-studio' do
    resources :access_codes, :path => "campaigns"
    resources :speeches, :path => "articles"
  end
  
  resources :skills
  get 'dashboard/index'

  #devise_for :users
  devise_for :users, :controllers => {:passwords => 'passwords', :sessions => 'sessions', :registrations => "registrations"}, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'signup' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  authenticated :user do
    root to: 'dashboard#index', as: :authenticated_root
  end
  root to: redirect('/auth/login')

  # Amazon comes in with a post request
  post '/skill/handler' => 'skills#root', :as => :skill_handler

  get "users/check_username", :controller => "registrations", :action => "check_username"
  
  get "speeches/published_details/:speech_id" => "speeches#published_details", as: "published_details"

  get "/voice-chimp-skill/details" => "skills#published_skill_details", as: "published_skill_details"

  post "/voice-reader-studio/articles/getArticlesByType" => "speeches#getArticlesByType", as: "getArticlesByType"
  
  
  devise_scope :user do
    patch "/confirm" => "confirmations#confirm"
    patch '/users/update_password' => "users#update_password"
    get "auth/signup/instructions", :controller => "registrations", :action => "instructions"
    
  end
  
  resource :user, only: [:edit] do
    collection do
      #patch 'update_password'
    end
  end
  
end
