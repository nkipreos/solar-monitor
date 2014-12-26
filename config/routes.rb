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

  namespace :dashboard do

  end

end