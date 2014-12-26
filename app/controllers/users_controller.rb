class UsersController < ApplicationController
  def sign_in

  end

  def create_user

  end

  def create_session
    user = User.find_by_email(params[:email])
    if !user.nil? && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to '/dashboard'
    else
      flash[:error] = "Your Credentials are invalid"
      render 'users/sign_in'
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to '/'
  end
end
