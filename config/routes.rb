Rails.application.routes.draw do
  devise_for :users
  root to: "bots#index"

  resources :bots
end
