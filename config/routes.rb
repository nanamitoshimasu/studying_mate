Rails.application.routes.draw do
  root "tops#index"
  post '/auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  delete 'log_out', to: 'sessions#destroy', as: 'log_out'

  resources :users, only: %i[destroy]
  resources :sessions, only: %i[create destroy]
end
