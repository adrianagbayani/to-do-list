if @user.present?
  json.user do
    json.auth_token @user.auth_token
  end
else
  json.authentication_error true
end
