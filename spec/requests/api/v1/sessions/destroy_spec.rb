require 'rails_helper'

describe "POST /users/sign_out" do
	before do
		user = FactoryGirl.create(:user)
		user.generate_auth_token

		headers["X-Auth-Token"] = user.auth_token
	end

	it "return auth_token on successful sign out" do
		post '/users/sign_out', nil, headers

		expect(json["user"]).to be_present
		expect(json["user"]["auth_token"]).to be_nil
	end

	it "returns empty json on failed sign in" do
		headers["X-Auth-Token"] = nil

		post '/users/sign_out', nil, headers

		expect(json).to be_present
		expect(json["user"]).to be_nil
	end
end
