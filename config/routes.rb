Rails.application.routes.draw do
  devise_for :users
  root to: "bots#index"

  resources :bots do
    resources :bot_instances
  end

  get 'authentication/login_redirect_target'
end
