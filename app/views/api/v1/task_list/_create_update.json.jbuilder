if @task_list.errors.empty?
  json.task_list do
    json.partial! 'task_list', locals: { task_list: @task_list}
  end
else
  json.errors @task_list.errors.messages
end
