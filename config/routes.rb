Rails.application.routes.draw do

  root to: 'users#sign_in'
  
  scope path: '/users', controller: :users do
    get 'sign_in' => :sign_in, as: 'login'
    post 'create_session' => :create_session, as: 'create_session'
    get 'logout' => :logout
  end

  scope accounts: '/accounts', controller: :accounts do
    get 'new' => :new, as: 'new_account'
    post 'create' => :create, as: 'create_account'
  end

  scope path: '/dashboard', controller: :dashboard do
    get 'show' => :show, as: 'dashboard_show'
  end

  scope path: '/streams', controller: :streams do
    get 'show' => :show, as: 'show_streams'
    get 'new' => :new, as: 'new_stream'
    post 'create' => :create, as: 'create_stream'
  end

  scope path: '/remote_devices', controller: :remote_devices do
    post 'create' => :create, as: 'create_remote_device'
  end

  scope path: '/api', controller: :data do
    post 'new_data' => :create
    post 'telegram' => :index
  end


end