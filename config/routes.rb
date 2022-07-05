Rails.application.routes.draw do
 
  resources :posts do 
    resources :comments
  end
  
  get '/about', to: 'pages#about'
  

  root 'pages#home'
  devise_for :users, controllers: {
    sessions: "user/sessions",
    registrations: "user/registrations"
  }

end
