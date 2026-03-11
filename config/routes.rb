require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
  mount Sidekiq::Web => "/sidekiq"

  namespace :admin do
    resources :notifications, only: [:create, :index, :show] do
      member do
        post :send_notification
      end
    end
  end

  resources :notifications, only: [:index] do
    member do
      post :read
    end
  end
end