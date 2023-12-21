Rails.application.routes.draw do
  root "tops#index"
  get '/auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  delete 'log_out', to: 'sessions#destroy', as: 'log_out'

  resources :teams
  resources :sessions, only: %i[create destroy]
  resource :profile, only: %i[show edit update]
  
  # 他の全てのurlがget '/:username'で処理されないように最下部に
  get '/:username', to: 'users#show'
  delete '/users/:id', to: 'users#destroy'
end
