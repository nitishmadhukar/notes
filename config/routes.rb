Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    post 'auth/signup', to: 'auth#signup'
    post 'auth/login', to: 'auth#login'
    resources :notes
    get 'search', to: 'search#search'
  end
end
