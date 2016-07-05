Rails.application.routes.draw do
  resources :articles
  resources :schedules

  root 'welcome#index'
end
