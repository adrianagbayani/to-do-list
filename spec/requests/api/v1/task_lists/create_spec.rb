require 'rails_helper'

describe "POST /task_lists" do

	context "unauthorized" do
		it "returns authorization error" do
			post '/task_lists', nil, headers

			expect(json).to include("authentication_error")
			expect(json["authentication_error"]).to be_truthy
		end
	end

	context "authorized" do
		let!(:user) {{}}

		before do
			user = FactoryGirl.create(:user)
			user.generate_auth_token

			headers['X-Auth-Token'] = user.auth_token
		end

		it "returns json upon successful creation" do
			post_data = {
				task_list: {
					name: 'Task List'
				}
			}

			post '/task_lists', post_data.to_json, headers

			expect(json).to include("task_list")
			expect(json["task_list"]["id"]).to be_present
			expect(json["task_list"]["name"]).to eq(post_data[:task_list][:name])
			expect(json["task_list"]["user"]).to be_present
		end

		it "return error messags on blank form" do
			post '/task_lists', nil, headers

			expect(json).to include("errors")
			expect(json["errors"]).to be_present
			expect(json["errors"]["name"]).to be_present
			expect(json["errors"]["name"]).to include("can't be blank")
		end

		it "return error messags on blank form" do
			post_data = {
				task_list: {
					name: 'Short'
				}
			}

			post '/task_lists', post_data.to_json, headers

			expect(json).to include("errors")
			expect(json["errors"]).to be_present
			expect(json["errors"]["name"]).to be_present
			expect(json["errors"]["name"]).to include("is too short (minimum is 6 characters)")
		end
	end
end
