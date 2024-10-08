Rails.application.routes.draw do
  get 'groups/index'
  get 'groups/show'
  get 'groups/new'
  get 'chat_rooms/index'
  get 'chat_rooms/show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "homes#top"
  get "home/about"=>"homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorite, only: [:create, :destroy]
  end

  devise_for :users
  resources :users, only: [:index,:show,:edit,:update] do
    member do
      get :following, :followers
      get :date_books
    end
  end

  resources :relationships, onry: [:create, :destroy]

  resources :chat_rooms do
    resources :direct_messages, only: [:create]
  end
  
  resources :groups
  resources :group_users, only: [:create, :destroy]
  get "search", to: "searches#search", as: "search"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
