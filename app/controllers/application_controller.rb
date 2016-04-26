class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.


  before_filter :authenticate_user, unless: :authentication_controller?

	protected

	def authentication_controller?
    true
  end

  def authenticate_user
    auth_token = request.headers["X-Auth-Token"]

    if auth_token.present?
      @current_user = User.where(auth_token: auth_token).first
    end

    if @current_user.nil?
      render json: { authentication_error: true }
    end
  end
end
