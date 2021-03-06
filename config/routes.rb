# frozen_string_literal: true

Rails.application.routes.draw do
  resource :session, only: %i[new create destroy]

  resources :users, only: %i[new create edit update]

  resources :questions do
    resources :comments, only: %i[create destroy]

    resources :answers, except: %i[new show]
  end

  resources :answers, except: %i[new show] do
    resources :comments, only: %i[create destroy]
end

  root 'pages#index'
end
