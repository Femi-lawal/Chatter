# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :accounts, controllers: {
    registrations: 'accounts/registrations',
    sessions: 'accounts/sessions'
  }

  root "static_pages#home"

  resources :accounts do
    member do
      get :following, :followers
    end
  end
  resources :chaats,        only: [:index, :create, :destroy]
  resources :account_relationships, only: [:create, :destroy]

  get "help",    to: "static_pages#help"
  get "about",   to: "static_pages#about"
  get "contact", to: 'static_pages#contact'

  match "*path" => "application#routing_error", via: :all
end
