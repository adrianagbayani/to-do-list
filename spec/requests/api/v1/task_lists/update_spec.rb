require 'rails_helper'

describe "GET /task_list/:id" do
	context "unauthorized" do
		it "returns authorization error" do
			patch '/task_lists/1', nil, headers

			expect(json).to include("authentication_error")
			expect(json["authentication_error"]).to be_truthy
		end
	end

	context "authorized" do
		let!(:user) {
			FactoryGirl.create(:user)
		}

		before do
			user.generate_auth_token

			task_list = FactoryGirl.create(:task_list, :user => user)

			headers['X-Auth-Token'] = user.auth_token
		end

		it 'return empty task list' do
			patch '/task_lists/2', nil, headers

			expect(json["errors"]).to be_present
			expect(json["errors"]).to eq("Object not found")
		end

		it 'returns task list' do
			post_data = {
				task_list: {
					name: 'Task List 2'
				}
			}

			patch '/task_lists/1', post_data.to_json, headers

			expect(json["task_list"]).to be_present
			expect(json["task_list"]["id"]).to be_present
			expect(json["task_list"]["name"]).to eq(post_data[:task_list][:name])
			expect(json["task_list"]["user"]).to be_present
		end

		it "return error messags on blank form" do
			post_data = {
				task_list: {
					name: ''
				}
			}

			patch '/task_lists/1', post_data.to_json, headers

			expect(json).to include("errors")
			expect(json["errors"]).to be_present
			expect(json["errors"]["name"]).to be_present
			expect(json["errors"]["name"]).to include("can't be blank")
		end

		it "return error messags on short form" do
			post_data = {
				task_list: {
					name: 'Short'
				}
			}

			patch '/task_lists/1', post_data.to_json, headers

			expect(json).to include("errors")
			expect(json["errors"]).to be_present
			expect(json["errors"]["name"]).to be_present
			expect(json["errors"]["name"]).to include("is too short (minimum is 6 characters)")
		end
	end
end
