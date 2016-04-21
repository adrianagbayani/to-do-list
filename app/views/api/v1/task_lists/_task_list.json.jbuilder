json.task_list do
	json.id task_list.id
	json.name task_list.name
	json.partial! 'api/v1/users/user', locals: { user: task_list.user }
	json.tasks do
	  json.partial! 'api/v1/tasks/task', collection: task_list.tasks, as: :task
	end
end
