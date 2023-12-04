Rails.application.routes.draw do
  get '/current_user', to: 'current_user#index'
  devise_for :users, path: '/users', path_names: {
      sign_in: '/sign_in',
    },
  controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
