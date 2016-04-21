require 'rails_helper'

describe "POST /users/sign_in" do
	before do
		FactoryGirl.create(:user)
	end

	it "return auth_token on successful sign in" do
		post_data = {
			user: {
				username: "username",
				password: "password"
			}
		}

		post '/users/sign_in', post_data.to_json, headers

		expect(json["user"]).to be_present
		expect(json["user"]["auth_token"]).to be_present
	end

	it "returns empty json on failed sign in" do
		post_data = {
			user: {
				username: "username",
				password: "password1"
			}
		}

		post '/users/sign_in', post_data.to_json, headers

		expect(json).to be_present
		expect(json["user"]).to be_nil
	end
end
