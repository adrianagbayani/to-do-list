if @user.present? && @user.auth_token.present?
  json.user do
    json.auth_token @user.auth_token
  end
end

if @errors.present?
  json.errors @errors
end
