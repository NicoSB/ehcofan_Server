Rails.application.routes.draw do
  resources :articles
  resources :schedules
  resources :matches
  resources :players
  resources :teams

  root 'welcome#index'
end
