Rails.application.routes.draw do
  resources :articles
  resources :schedules
  resources :matches

  root 'welcome#index'
end
