Rails.application.routes.draw do
  
  scope path: '/users', controller: :users do
    get 'sign_in' => :sign_in, as: 'login'
    get 'sign_up' => :sign_up
    post 'create_session' => :create_session, as: 'create_session'
  end

  scope accounts: '/accounts', controller: :accounts do
    get 'new' => :new, as: 'new_account'
    post 'create' => :new, as: 'create_account'
  end

end