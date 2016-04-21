json.task_lists do
  json.partial! 'task_list', collection: @task_lists, as: :task_list
end
