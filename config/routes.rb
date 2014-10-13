Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#index'
  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end
  end
  resources :categories, only: [:show]
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  get 'register', to: 'users#new'
  resources :users, only: [:create]
  resources :sessions, only: [:create]

end
