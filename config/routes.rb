Rails.application.routes.draw do
  get '/current_user', to: 'current_user#index'
  devise_for :users, path: '/users', path_names: {
      sign_in: '/sign_in',
      # log_out: '/log_out'
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

  post '/invoices/:invoice_id/create_checkout_session', to: 'counselling/checkout#create'
  get '/invoices/:invoice_id/session-status', to: 'counselling/checkout#session_status'
  ## Store API
  resources :users, only: [:show] do
    scope module: 'store' do
      resources :orders
    end
  end

  patch '/cart/cart_items/:id', to: 'store/cart_items#update'
  delete '/cart/cart_items/:id', to: 'store/cart_items#destroy'
  get '/cart', to: 'store/carts#show'
  post '/orders/:order_id/create_checkout_session', to: 'store/checkout#create'
  get '/orders/:order_id/session-status', to: 'store/checkout#session_status'
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
