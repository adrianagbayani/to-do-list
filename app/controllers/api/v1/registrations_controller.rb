class Api::V1::RegistrationsController < Api::V1::AuthenticationController
  def create
    @user = User.create(sign_up_params)

    if @user.errors.empty?
      @user.generate_auth_token
    else
      @errors = @user.errors.messages
    end
  end

  private

  def sign_up_params
    if params[:user].present?
      params[:user].permit(:username,
                           :password,
                           :password_confirmation,
                           :email,
                           :device_token)
    end
  end
end
