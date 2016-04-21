require 'rails_helper'

describe "POST /tasks/1/tasks/1/notes" do
	context "unauthorized" do
		it "returns authorization error" do
			delete '/task_lists/1/tasks/1/notes/1', nil, headers

			expect(json).to include("authentication_error")
			expect(json["authentication_error"]).to be_truthy
		end
	end

	context "authorized" do
		let!(:user) {{}}
		let!(:task_list) {{}}
		let!(:task) {{}}
		let!(:note) {{}}

		before do
			user = FactoryGirl.create(:user)
			user.generate_auth_token

			task_list = FactoryGirl.create(:task_list, :user => user)
			task = FactoryGirl.create(:task, :user => user)
			note = FactoryGirl.create(:note, :user => user)

			headers['X-Auth-Token'] = user.auth_token
		end

		it "returns json upon successful deletion" do
			delete '/task_lists/1/tasks/1/notes/1', nil, headers

			expect(json).to include("note")
			expect(json["note"]["id"]).to be_present
			expect(json["note"]["message"]).to eq("Message")
			expect(Note.count).to eq(0)
		end

		it "returns error" do
			delete '/task_lists/1/tasks/1/notes/2', nil, headers

			expect(json["errors"]).to be_present
			expect(json["errors"]).to eq("Object not found")
		end
	end
end
