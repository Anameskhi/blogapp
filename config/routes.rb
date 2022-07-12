Rails.application.routes.draw do
  get 'search', to: "search#index"
 
  resources :posts do 
    resources :comments 
    resources :likes

  end
  
  get '/about', to: 'pages#about'



  root 'pages#home'
  # devise_for :users, controllers: {  }
  devise_for :users, only: :omniauth_callbacks, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}

  devise_for :users, skip: :omniauth_callbacks, controllers: {
    sessions: "user/sessions",
    registrations: "user/registrations",
    
   
  }



  match '/auth/:provider/callback', :to => 'omniauth#google_oauth2', :via => [:get, :post]
  
  

  OmniAuth.config.allowed_request_methods = [:get]

  
end
