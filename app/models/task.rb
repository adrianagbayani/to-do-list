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

class Task < ActiveRecord::Base
  belongs_to :task_list
	belongs_to :user

	has_many :notes

  validates :title,
    presence: true,
    length: 6..20

	def complete_task
		unless complete
			update({ complete: true })
		end
	end

	def self.eager_load_task(id)
		eager_load([:user, :notes => :user]).where(id: id)[0]
	end
end
