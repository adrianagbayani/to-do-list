require 'rails_helper'

describe "GET /task_lists" do
	context "unauthorized" do
		it "returns authorization error" do
			get '/task_lists', nil, headers

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

		it 'returns list of task lists' do
			FactoryGirl.create(:task_list, :user => user)
			FactoryGirl.create(:task_list, :user => user)
			FactoryGirl.create(:task_list, :user => user)

			get '/task_lists', nil, headers

			expect(json["task_lists"]).to be_present
			expect(json["task_lists"].length).to eq(3)
		end
	end
end
