Rails.application.routes.draw do
  root "tops#index"
  get '/auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  delete 'log_out', to: 'sessions#destroy', as: 'log_out'
  get '/:username', to: 'user#show'

  resources :users, only: %i[show destroy]
  resources :sessions, only: %i[create destroy]
  resource :profile, only: %i[show edit update]
end
