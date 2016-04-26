require 'rails_helper'

describe "POST /tasks_lists/1/tasks/1/notes" do
	context "unauthorized" do
		it "returns authorization error" do
			post '/task_lists/1/tasks/1/notes', nil, headers

			expect(json).to include("authentication_error")
			expect(json["authentication_error"]).to be_truthy
		end
	end

	context "authorized" do
		let!(:user) {{}}
		let!(:task_list) {{}}

		before do
			user = FactoryGirl.create(:user)
			user.generate_auth_token

			task_list = FactoryGirl.create(:task_list, :user => user)

			task = FactoryGirl.create(:task, :user => user)

			headers['X-Auth-Token'] = user.auth_token
		end

		it "returns json upon successful creation" do
			post_data = {
				note: {
					message: 'Task List'
				}
			}

			post '/task_lists/1/tasks/1/notes', post_data.to_json, headers

			expect(json["id"]).to be_present
			expect(json["message"]).to eq(post_data[:note][:message])
			expect(json["user"]).to be_present
		end

		it "return error messags on blank form" do
			post '/task_lists/1/tasks/1/notes', nil, headers

			expect(json).to include("errors")
			expect(json["errors"]).to be_present
			expect(json["errors"]["message"]).to be_present
			expect(json["errors"]["message"]).to include("can't be blank")
		end
	end
end
