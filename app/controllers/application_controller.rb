class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def authenticate_user
    unless session[:user].present?
      flash[:alert] = "Please setup Paypal REST API User <a href=#{new_session_path}>here!</a>"
      redirect_to root_path
    end
  end
end
