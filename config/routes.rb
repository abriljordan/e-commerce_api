# config/routes.rb
Rails.application.routes.draw do
    # User authentication routes
    post '/signup', to: 'authentication#signup'
    post '/login', to: 'authentication#login'
  
    # Product routes (some are admin-only)
    resources :products, only: [:index, :create, :update, :destroy]
  end