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

class Note < ActiveRecord::Base
  belongs_to :task
	belongs_to :user

	validates :message,
		presence: true

	def self.eager_load_note(id)
		Note.eager_load([:user]).where(id: id)[0]
	end
end
