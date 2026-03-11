require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  namespace :admin do
    resources :notifications, only: [:create, :index, :show] do
      member do
        post :send_notification
      end
    end
  end
end