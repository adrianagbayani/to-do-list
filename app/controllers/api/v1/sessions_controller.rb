class Api::V1::SessionsController < Api::V1::AuthenticationController

  def create
    @user = User.authenticate_user(sign_in_params)

		if @user.nil?
			render_empty_json
		end
  end

	def destroy
		authenticate_user

		if @current_user.present?
			@current_user.destroy_token
		end
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
