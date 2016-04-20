require 'bcrypt'
require 'securerandom'

class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation

	has_many :task_lists
	has_many :tasks
	has_many :notes

  validates :username,
    presence: true,
    uniqueness: true

  validates_presence_of :password, on: :create
  validates_confirmation_of :password, on: :create
  validates_length_of :password, in: 6..32, on: :create

  validates_presence_of :password_confirmation, on: :create

  validates :email,
    presence: true,
    uniqueness: true,
    format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  validates :device_token,
    presence: true

  def password=(new_password)
    @password = new_password
    self.encrypted_password = User.encrypt(new_password)
  end

  def destroy_token
    update({ auth_token: nil })
  end

  def generate_auth_token
    self.update({ auth_token: friendly_token})
  end

  def self.authenticate_user(login_params)
    password = login_params.delete(:password)
    user = where(login_params.to_h).first

    if User.compare(user.encrypted_password, password)
      user.generate_auth_token
      binding.pry
      return user
    else
      return nil
    end
  end

  private
  def friendly_token(length = 32)
    # To calculate real characters, we must perform this operation.
    # See SecureRandom.urlsafe_base64
    rlength = (length * 3) / 4
    SecureRandom.urlsafe_base64(rlength).tr('lIO0', 'sxyz')
  end

  def self.compare(encrypted_password, password)
    BCrypt::Password.new(encrypted_password) == password
  end

  def self.encrypt(password)
    BCrypt::Password.create(password)
  end

end
