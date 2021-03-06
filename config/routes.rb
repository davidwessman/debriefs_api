require 'api_constraints'
Rails.application.routes.draw do
  mount SabisuRails::Engine => "/sabisu_rails"
  devise_for :users
  namespace :api, defaults: { format: :json },
                  constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: [:create, :show, :update, :destroy]
      resources :sessions, only: [:create, :destroy]
      resources :subscriptions, only: [:show, :index, :create, :update, :destroy]
    end
  end
end
