class Task < ActiveRecord::Base
  belongs_to :task_list

  validates :title,
    presence: true,
    length: 6..20
end
