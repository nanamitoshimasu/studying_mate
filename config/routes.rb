Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  root 'tops#index'
  get '/auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  delete 'log_out', to: 'sessions#destroy', as: 'log_out'
  get 'privacy_policy', to: 'tops#privacy_policy'
  get 'terms_of_service', to: 'tops#terms_of_service'
  
  resources :teams do
    resource :attendance, only: %i[create destroy], module: :teams
    member do
      get 'member_page'
    end
    resources :timers, only: %i[new create update] do
      get 'edit_all_timestamps', on: :member
      patch 'update_all_timestamps', on: :member
      resources :break_times, only: %i[create update]
    end
    resource :room, only: %i[show]
  end

  resources :sessions, only: %i[create destroy]
  resource :profile, only: %i[show edit update]

  resources :users, only: %i[show]
end
