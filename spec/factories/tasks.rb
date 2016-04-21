# == Schema Information
#
# Table name: tasks
#
#  id           :integer          not null, primary key
#  task_list_id :integer
#  title        :string
#  due_date     :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#  complete     :boolean
#

FactoryGirl.define do
  factory :task do
    task_list nil
    title "Go To Store"
    due_date "2016-04-20 00:00:00"
  end
end
