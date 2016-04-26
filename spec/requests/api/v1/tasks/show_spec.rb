require 'rails_helper'

describe "GET /tasks_lists/1/tasks/1" do
	context "unauthorized" do
		it "returns authorization error" do
			get '/task_lists/1/tasks/1', nil, headers

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
			get '/task_lists/1/tasks/2', nil, headers

			expect(json["errors"]).to be_present
			expect(json["errors"]).to eq("Object not found")
		end

		it "returns json upon successful completion" do
			get '/task_lists/1/tasks/1', nil, headers

			expect(json["id"]).to be_present
			expect(json).to include("complete")
			expect(json["title"]).to eq("Go To Store")
			expect(json["due_date"]).to eq("2016-04-20T00:00:00.000Z")
			expect(json["user"]).to be_present
		end
	end
end
