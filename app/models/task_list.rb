# == Schema Information
#
# Table name: task_lists
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class TaskList < ActiveRecord::Base

	belongs_to :user

  has_many :tasks

  validates :name,
    presence: true,
    length: 6..20

	def self.eager_load_task_list(id)
		eager_load([:user, :tasks => [:user, :notes => :user]]).where(id: id)[0]
	end
end
