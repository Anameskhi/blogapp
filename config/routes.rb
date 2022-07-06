Rails.application.routes.draw do
 
  resources :posts do 
    resources :comments 
    resources :likes

  end
  
  get '/about', to: 'pages#about'
  get '/auth/:provider/callback', to: 'sessions#create'


  root 'pages#home'
  devise_for :users, controllers: {
    sessions: "user/sessions",
    registrations: "user/registrations",
    omniauth_callbacks: 'user/omniauth_callbacks' 
  }
 

  
end
