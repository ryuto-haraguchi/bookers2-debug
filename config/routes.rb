Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "homes#top"
  get "home/about"=>"homes#about"

  get 'tag_search', to: 'books#tag_search', as: 'tag_search'

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

  resources :relationships, only: [:create, :destroy]

  resources :chat_rooms do
    resources :direct_messages, only: [:create]
  end

  resources :groups do
    resources :group_users, only: [:create, :destroy]
    member do
      get :new_event_notice
      post :send_event_notice
      get :sent_event_notice
    end
  end
  get "search", to: "searches#search", as: "search"

  resources :notifications, only:[:update]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
