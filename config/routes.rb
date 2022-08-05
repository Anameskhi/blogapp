# frozen_string_literal: true

Rails.application.routes.draw do
  resources :subscriptions, only: %i[new create]
  resources :categories
  scope '(:locale)', locale: /en|ka/ do
    authenticated :user, ->(user) { user.admin? } do
      get 'admin', to: 'admin#index'
      get 'admin/posts'
      get 'admin/comments'
      get 'admin/users'
      get 'admin/admin_show_user/:id', to: 'admin#show_user', as: 'admin_show_user'
      get 'admin/show_post/:id', to: 'admin#show_post', as: 'admin_post'
    end

    authenticated :user, ->(user) { user.subscribed? } do
      get 'premium/posts', to: 'posts#premium'
    end
    get 'vip/user', to: 'checkouts#vip'

    get 'search', to: 'search#index'
    
    
    resources :posts do
      resources :comments
      resources :likes
    end

    namespace :api do
      namespace :v1 do
        post "/webhook", to: "stripe_subscriptions#webhook"
      end
    end

    get '/about', to: 'pages#about'
    get '/user/:id', to: 'users#show', as: 'user_profile'
    root 'pages#home'
    delete 'user/:id/admin_delete', to: "admin#admin_delete_user", as: :admin_delete_user 

    # devise_for :users, controllers: {  }

    devise_for :users, skip: :omniauth_callbacks, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords'
    }
  end

  devise_for :users, only: :omniauth_callbacks, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  match '/auth/:provider/callback', to: 'omniauth#google_oauth2', via: %i[get post]

  OmniAuth.config.allowed_request_methods = [:get]
end
