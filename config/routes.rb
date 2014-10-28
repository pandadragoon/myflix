Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#index'
  get 'my_queue', to: 'queue_items#index'
  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end
  resources :users, only: [:show]
  resources :categories, only: [:show]
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  get 'register', to: 'users#new'
  get 'people', to: 'relationships#index'
  resources :relationships, only: [:destroy]
  resources :users, only: [:create]
  resources :sessions, only: [:create]
  resources :queue_items, only: [:create, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'
end
