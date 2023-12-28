# frozen_string_literal: true

Rails.application.routes.draw do
  scope :admin do
    get '/', to: 'admin#index'
    post '/', to: 'admin#create_experiment', as: :create_experiment
    patch '/', to: 'admin#complete_experiment', as: :complete_experiment
    post '/add_devices', to: 'admin#add_test_devices', as: :add_test_devices
    get '/logout', to: 'admin#logout'
    match '/authenticate', to: 'admin#authenticate', via: %i[get post]
    match '/create_user', to: 'admin#create_user', via: %i[get post]
  end
  get '/change_locale', to: 'application#change_locale', as: :change_locale
  get 'up' => 'rails/health#show', as: :rails_health_check
  root 'admin#index'
  mount Api::Engine, at: '/api'
end
