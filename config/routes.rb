Rails.application.routes.draw do
  devise_for :users
  root to: "bots#index"
  
  resources :bots do
    resources :bot_instances
  end
  post 'bots/:bot/collaborators', to: 'bots#add_collaborator'

  scope "authentication" do
    get 'login_redirect_target', to: 'authentication#login_redirect_target'

    if Rails.env.development?
      get 'dev-login', to: 'authentication#dev_login'
      post 'dev-login', to: 'authentication#submit_dev_login'
    end
  end
end
