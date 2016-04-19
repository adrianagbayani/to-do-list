class Api::V1::SessionsController < Api::V1::AuthenticationController

  def create
    @user = User.authenticate_user(sign_in_params)
  end

  protected
  def sign_in_params
    if params[:user].present?
      params[:user].permit(:username,
                           :password,
                           :device_token)
    end
  end

end
