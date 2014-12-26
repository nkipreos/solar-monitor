class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate

  def authenticate
    permitted_urls = ["users_sign_in", "users_create_session", "accounts_new", "accounts_create"]
    unless permitted_urls.include?("#{controller_name}_#{action_name}")
      if session[:user_id].nil?
        render_unauthorized
      else
        @current_user = User.find(session[:user_id])
        unless @current_user 
          render_unauthorized
        end
      end
    end
  end

  private

  def render_unauthorized
    render :file => "public/401.html", :status => :unauthorized
  end
end
