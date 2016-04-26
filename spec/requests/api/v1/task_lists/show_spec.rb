require 'rails_helper'

describe "GET /task_list/:id" do
	context "unauthorized" do
		it "returns authorization error" do
			get '/task_lists/1', nil, headers

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
			get '/task_lists/1', nil, headers

			expect(json["errors"]).to be_present
			expect(json["errors"]).to eq("Object not found")
		end

		it 'returns task list' do
			task_list = FactoryGirl.create(:task_list, :user => user)

			get '/task_lists/1', nil, headers

			expect(json["id"]).to be_present
			expect(json["name"]).to eq(task_list[:name])
			expect(json["user"]).to be_present
		end
	end
end
