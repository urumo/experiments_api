# frozen_string_literal: true

Rails.application.routes.draw do
  scope :admin do
    get '/', to: 'admin#index'
    get '/logout', to: 'admin#logout'
    match '/authenticate', to: 'admin#authenticate', via: %i[get post]
    match '/create_user', to: 'admin#create_user', via: %i[get post]
  end
  resources :experiments
  get 'up' => 'rails/health#show', as: :rails_health_check
  root 'admin#index'
end
