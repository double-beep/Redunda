Rails.application.routes.draw do

  root to: 'bots#index'

  get 'users', to: 'users#index'
  devise_for :users

  get    'bots/data.json',                        to: 'bots#list_data',           as: :list_data
  get    'bots/data/:data_key',                   to: 'bots#get_data',            as: :get_data, constraints: {:data_key => /[\w\.]+/}
  get    'bots/:id',                              to: 'bots#show',                as: :bot_show
  post   'bots/data/:data_key',                   to: 'bots#update_data',         as: :update_data, constraints: {:data_key => /[\w\.]+/}
  post   'bots/:id/events/:name',                 to: 'bots#add_event',           as: :add_event
  post   'bots/:bot/collaborators',               to: 'bots#add_collaborator',    as: :add_collaborator
  delete 'bots/:bot/collaborators/:collaborator', to: 'bots#remove_collaborator', as: :remove_collaborator
  delete 'bots/data/:data_key',                   to: 'bots#remove_data',         as: :remove_data, constraints: {:data_key => /[\w\.]+/}
  delete 'bots/:id/data/:data_key',               to: 'bots#web_remove_data',     as: :web_remove_data, constraints: {:data_key => /[\w\.]+/}
  resources :bots do
    resources :bot_instances
  end


  get 'bot_instances/show'
  post 'bots/:bot_id/bot_instances/reorder',        to: 'bot_instances#reorder',     as: :reorder
  post 'status.json',                               to: 'bot_instances#status_ping', as: :status_ping
  post 'events.json',                               to: 'bot_instances#show_events', as: :show_events
  post 'bots/:bot_id/bot_instances/:id/revoke_key', to: 'bot_instances#revoke_key',  as: :revoke_key

  get 'status/code.json',                           to: 'code_status#api'
  get 'status/code',                                to: 'code_status#index',         as: :code_status


  scope 'authentication' do
    get 'login_redirect_target', to: 'authentication#login_redirect_target'

    if Rails.env.development?
      get 'dev-login',           to: 'authentication#dev_login'
      post 'dev-login',          to: 'authentication#submit_dev_login'
    end
  end

  scope 'admin' do
    root to: 'admin#index'
    get 'permissions', to: 'admin#user_permissions'
    put 'permissions', to: 'admin#update_permissions'
  end
end
