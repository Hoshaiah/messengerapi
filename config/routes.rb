Rails.application.routes.draw do
  resources :friendrequests
  # post 'friendships/', to: 'friendships#create', as: 'create_friendship'
  # get 'friendships/', to: 'friendships#index', as: 'get_friendship'
  resources :friendships
  # devise_for :users
  mount ActionCable.server => '/cable'
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get 'users/search', to: 'users#search', as: 'search_users'
  resources :messages
  resources :channels
  resources :channel_users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
