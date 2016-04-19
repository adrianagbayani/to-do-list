json.id task_list.id
json.name task_list.name
json.tasks do
  json.partial! 'api/v1/task/task', collection: task_list.tasks, as: :task
end
