require 'rails_helper'

describe "POST /users/" do
	it "returns token on successful registration" do
		post_data = {
			user: {
				username: "username",
				password: "password",
				password_confirmation: "password",
				email: "test@email.com",
				device_token: "device_token"
			}
		}

		post "/users", post_data.to_json, headers

		expect(json["user"]).to be_present
		expect(json["user"]["auth_token"]).to be_present
	end

	it "return error message on empty form" do
		post "/users", nil, headers

		expect(json["errors"]).to be_present
		expect(json["errors"]["username"]).to include("can't be blank")
		expect(json["errors"]["password"]).to include("can't be blank")
		expect(json["errors"]["password_confirmation"]).to include("can't be blank")
		expect(json["errors"]["email"]).to include("can't be blank")
		expect(json["errors"]["device_token"]).to include("can't be blank")
	end

	it "returns error message on error form" do
		post_data = {
			user: {
				username: "short",
				password: "short",
				password_confirmation: "password",
				email: "invalid",
				device_token: "device_token"
			}
		}

		post "/users", post_data.to_json, headers

		expect(json["errors"]).to be_present
		expect(json["errors"]["username"]).to include("is too short (minimum is 6 characters)")
		expect(json["errors"]["password"]).to include("is too short (minimum is 6 characters)")
		expect(json["errors"]["password_confirmation"]).to include("doesn't match Password")
		expect(json["errors"]["email"]).to include("is invalid")
	end
end
