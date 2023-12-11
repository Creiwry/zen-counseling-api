Rails.application.routes.draw do
  get '/current_user', to: 'current_user#index'
  get '/is_admin', to: 'current_user#is_admin'
  devise_for :users, path: '/users', path_names: {
      sign_in: '/sign_in',
    },
  controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }
  resources :updates

  ## Counselling API
  resources :users, only: [:show] do
    scope module: 'counselling' do
      resources :invoices do
        resources :appointments
      end
    end
  end

  ## Store API
  resources :users, only: [:show] do
    scope module: 'store' do
      resources :orders
    end
  end

  patch '/cart/cart_items/:id', to: 'store/cart_items#update'
  delete '/cart/cart_items/:id', to: 'store/cart_items#destroy'
  get '/cart', to: 'store/carts#show'
  scope module: 'store' do
    resources :items do
      resources :cart_items, only: [:create]
    end
    resources :orders, only: [:index, :show]
  end

  ## Counseling API
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
