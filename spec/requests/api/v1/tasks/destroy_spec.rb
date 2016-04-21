require 'rails_helper'

describe "DELETE /tasks/1/tasks/1" do
	context "unauthorized" do
		it "returns authorization error" do
			delete '/task_lists/1/tasks/1', nil, headers

			expect(json).to include("authentication_error")
			expect(json["authentication_error"]).to be_truthy
		end
	end

	context "authorized" do
		let!(:user) {{}}
		let!(:task_list) {{}}
		let!(:task) {{}}

		before do
			user = FactoryGirl.create(:user)
			user.generate_auth_token

			task_list = FactoryGirl.create(:task_list, :user => user)

			task = FactoryGirl.create(:task, :user => user)

			headers['X-Auth-Token'] = user.auth_token
		end

		it 'return empty task list' do
			delete '/task_lists/1/tasks/2', nil, headers

			expect(json["errors"]).to be_present
			expect(json["errors"]).to eq("Object not found")
		end

		it "returns json upon successful completion" do
			delete '/task_lists/1/tasks/1', nil, headers

			expect(json).to include("task")
			expect(json["task"]["id"]).to be_present
			expect(json["task"]).to include("complete")
			expect(json["task"]["title"]).to eq("Go To Store")
			expect(json["task"]["due_date"]).to eq("2016-04-20T00:00:00.000Z")
			expect(Task.count).to eq(0)
		end
	end
end
