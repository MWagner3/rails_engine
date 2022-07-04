# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      # possibly route all non-restfull to own controller?
      get '/items/find_all', to: 'items#find_all'
      get '/merchants/find', to: 'merchants#find'
      resources :merchants, only: %i[index show] do
        # get :most_items, to: 'merchants#most_items'
        get :most_items, on: :collection, controller: :merchants
        resources :items, controller: 'merchant_items', action: :index
      end
      resources :items do
        resources :merchant, controller: 'merchant_items', action: :show
      end
      namespace :revenue do
        resources :merchants, only: %i[index show]
        resources :items, only: [:index]
      end
    end
  end
end
