require 'rails_helper'

RSpec.describe User, type: :model do
  it " can destroy auth token" do
    user = User.create(build :user, :valid_user)
    user.generate_auth_token

    expect(user.auth_token).to exist



  end
end
