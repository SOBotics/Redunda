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

  post 'bots/:bot_id/bot_instances/reorder', to: 'bot_instances#reorder', as: :reorder

  post 'status.json', to: 'bot_instances#status_ping', as: :status_ping

  scope "authentication" do
    get 'login_redirect_target', to: 'authentication#login_redirect_target'

    if Rails.env.development?
      get 'dev-login', to: 'authentication#dev_login'
      post 'dev-login', to: 'authentication#submit_dev_login'
    end
  end

  scope "admin" do
    root to: 'admin#index'
    get 'permissions', to: 'admin#user_permissions'
    put 'permissions', to: 'admin#update_permissions'
  end
end
