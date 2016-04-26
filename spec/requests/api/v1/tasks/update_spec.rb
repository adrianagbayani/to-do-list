require 'rails_helper'

describe "PATCH /tasks_lists/1/tasks/1" do
	context "unauthorized" do
		it "returns authorization error" do
			patch '/task_lists/1/tasks/1', nil, headers

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

		it 'return empty task list' do
			patch '/task_lists/1/tasks/2', nil, headers

			expect(json["errors"]).to be_present
			expect(json["errors"]).to eq("Object not found")
		end

		it "returns json upon successful completion" do
			post_data = {
				task: {
					title: "Go To Stores",
					due_date: "4/21/2016"
				}
			}
			patch '/task_lists/1/tasks/1', post_data.to_json, headers

			expect(json["id"]).to be_present
			expect(json).to include("complete")
			expect(json["title"]).to eq("Go To Stores")
			expect(json["due_date"]).to eq("2016-04-21T00:00:00.000Z")
		end

		it "return error messags on blank form" do
			post_data = {
				task: {
					title: ''
				}
			}

			patch '/task_lists/1/tasks/1', post_data.to_json, headers

			expect(json).to include("errors")
			expect(json["errors"]).to be_present
			expect(json["errors"]["title"]).to be_present
			expect(json["errors"]["title"]).to include("can't be blank")
		end

		it "return error messags on short form" do
			post_data = {
				task: {
					title: 'Short'
				}
			}

			patch '/task_lists/1/tasks/1', post_data.to_json, headers

			expect(json).to include("errors")
			expect(json["errors"]).to be_present
			expect(json["errors"]["title"]).to be_present
			expect(json["errors"]["title"]).to include("is too short (minimum is 6 characters)")
		end
	end
end
