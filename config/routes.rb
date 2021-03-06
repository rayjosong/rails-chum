Rails.application.routes.draw do
  get 'events/create'
  get 'events/new'
  get 'notifications/show'
  # get 'messages/create'
  get 'announcements/create'
  # get 'chatroom/show'
  # get 'chatroom/create'
  get 'itineraries/index'
  get 'itineraries/new'
  get 'itineraries/create'
  match "/500", to: 'errors#internal_server_error', via: :all
  match "/404", to: 'errors#not_found', via: :all
  match "/422", to: 'errors#unacceptable', via: :all
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :itineraries do
    resources :events, only: [ :new, :create, :show ]
    resources :announcements, only: [ :new, :create, :show ]
    resources :itinerary_users, only: [:new, :create]
    # #confirm method
    member do
      patch :finalise
      patch :publish, only: [:publish]
      patch :unpublish, only: [:unpublish]
    end
    # accept and reject actions
  end

  get "/mytrips", to: "itineraries#mytrips"

  resources :itinerary_users, only: [] do
    member do
      patch :accept
      patch :reject
    end
  end

  resources :notifications, only: :index do
    member do
      patch :mark, only: [:mark]
    end
  end

  # to allow users to check on all of their chatrooms
  resources :chatrooms, only: [ :index, :show, :create ] do
    resources :messages, only: :create
  end

  resources :users, only: [:show] do
    resources :chatrooms, only: :create
  end

  resources :itineraries, only: :show do
    resources :reviews, only: [:new, :create]
  end
  # resources :itinerary_users, only: --> accept/rejectresources :reviews, only: [:new, :create]
end
