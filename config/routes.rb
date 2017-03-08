Rails.application.routes.draw do
  devise_for :users
  root to: "bots#index"

  resources :bots
  resources :bot_instances
  
  post 'bots/:bot/collaborators', to: 'bots#add_collaborator'

  get 'authentication/login_redirect_target'
end
