require 'rails_helper'

describe "POST /tasks/1/tasks" do
	context "unauthorized" do
		it "returns authorization error" do
			post '/task_lists/1/tasks', nil, headers

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

			headers['X-Auth-Token'] = user.auth_token
		end

		it "returns json upon successful creation" do
			post_data = {
				task: {
					title: 'Task List',
					due_date: '4/20/2016'
				}
			}

			post '/task_lists/1/tasks', post_data.to_json, headers

			expect(json).to include("task")
			expect(json["task"]["id"]).to be_present
			expect(json["task"]["title"]).to eq(post_data[:task][:title])
			expect(json["task"]["due_date"]).to eq("2016-04-20T00:00:00.000Z")
			expect(json["task"]["user"]).to be_present
		end

		it "return error messags on blank form" do
			post '/task_lists/1/tasks', nil, headers

			expect(json).to include("errors")
			expect(json["errors"]).to be_present
			expect(json["errors"]["title"]).to be_present
			expect(json["errors"]["title"]).to include("can't be blank")
		end

		it "return error messags on error form" do
			post_data = {
				task: {
					title: 'Short'
				}
			}

			post '/task_lists/1/tasks', post_data.to_json, headers

			expect(json).to include("errors")
			expect(json["errors"]).to be_present
			expect(json["errors"]["title"]).to be_present
			expect(json["errors"]["title"]).to include("is too short (minimum is 6 characters)")
		end
	end
end
