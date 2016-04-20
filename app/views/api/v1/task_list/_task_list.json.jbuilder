json.task_list do
	json.id task_list.id
	json.name task_list.name
	json.partial! 'api/v1/user/user', locals: { user: task_list.user }
	json.tasks do
	  json.partial! 'api/v1/task/task', collection: task_list.tasks, as: :task
	end
end
