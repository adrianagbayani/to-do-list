class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  # protect_from_forgery with: :null_session
  before_filter :authenticate_user, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:username,
               :email,
               :password,
               :password_confirmation,
               :device_token)
    end
    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(:login,
               :username,
               :email,
               :password,
               :device_token)
    end
  end

  def authenticate_user
    auth_token = request.headers["X-Auth-Token"]

    if auth_token.present?
      user = User.where(auth_token: auth_token).first
    end

    if user.nil?
      render "users/errors/authentication"
    end
  end
end
