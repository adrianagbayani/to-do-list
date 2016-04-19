class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  # protect_from_forgery with: :null_session
  before_filter :authenticate_user, unless: :authentication_controller?

  protected
  def authentication_controller?
    false
  end

  def authenticate_user
    binding.pry
    auth_token = request.headers["X-Auth-Token"]

    if auth_token.present?
      user = User.where(auth_token: auth_token).first
    end

    if user.nil?
      render "users/errors/authentication"
    end
  end
end
