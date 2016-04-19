class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def destroy_token
    update({ auth_token: nil })
  end

  def generate_auth_token
    update({ auth_token: Devise.friendly_token })
  end

  def self.authenticate_user(login_params)
    password = login_params.delete(:password)
    user = where(login_params.to_h).first

    if Devise::Encryptor.compare(self, user.encrypted_password, password);
      user.generate_auth_token

      return user
    else
      return nil
    end
  end
end
