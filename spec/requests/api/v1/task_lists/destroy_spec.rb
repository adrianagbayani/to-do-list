require 'rails_helper'

describe "GET /task_list/:id" do
	context "unauthorized" do
		it "returns authorization error" do
			delete '/task_lists/1', nil, headers

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

			headers['X-Auth-Token'] = user.auth_token
		end

		it 'return empty task list' do
			delete '/task_lists/1', nil, headers

			expect(json["errors"]).to be_present
			expect(json["errors"]).to eq("Object not found")
		end

		it 'returns task list' do
			task_list = FactoryGirl.create(:task_list, :user => user)

			delete '/task_lists/1', nil, headers

			expect(json["task_list"]).to be_present
			expect(json["task_list"]["id"]).to be_present
			expect(json["task_list"]["name"]).to eq(task_list[:name])
			expect(TaskList.count).to eq(0)
		end
	end
end
