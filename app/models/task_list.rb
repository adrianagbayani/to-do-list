class TaskList < ActiveRecord::Base
  validates :name,
    presence: true,
    length: 6..20

    has_many :tasks
end
