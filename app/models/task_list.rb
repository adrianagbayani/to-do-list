class TaskList < ActiveRecord::Base

	belongs_to :user

  has_many :tasks
	
  validates :name,
    presence: true,
    length: 6..20

end
