Rails.application.routes.draw do
  resources :playoffs
  get 'welcome/index'

  resources :articles
  resources :schedules
  resources :matches
  resources :players
  resources :teams

  root 'welcome#index'
end
