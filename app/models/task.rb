class Task < ActiveRecord::Base
  belongs_to :task_list
	belongs_to :user
	
	has_many :notes

  validates :title,
    presence: true,
    length: 6..20
end
