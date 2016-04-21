# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  task_id    :integer
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

FactoryGirl.define do
  factory :note do
    task nil
    message "Message"
  end
end
