Rails.application.routes.draw do
  get 'bot_instances/show'

    get 'users', to: 'users#index'

  devise_for :users
  root to: "bots#index"

  resources :bots do
    resources :bot_instances
  end
  post 'bots/:bot/collaborators', to: 'bots#add_collaborator', as: :add_collaborator
  delete 'bots/:bot/collaborators/:collaborator', to: 'bots#remove_collaborator', as: :remove_collaborator

  post 'status.json', to: 'bot_instances#status_ping', as: :status_ping

  scope "authentication" do
    get 'login_redirect_target', to: 'authentication#login_redirect_target'

    if Rails.env.development?
      get 'dev-login', to: 'authentication#dev_login'
      post 'dev-login', to: 'authentication#submit_dev_login'
    end
  end
end
