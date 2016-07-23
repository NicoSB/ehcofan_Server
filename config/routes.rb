Rails.application.routes.draw do
  resources :articles
  resources :schedules
  resources :matches
  resources :players

  root 'welcome#index'
end
