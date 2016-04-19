if @task.present?
  json.task_list do
    json.partial! 'task', locals: { task: @task}
  end
elsif @exception.present?
  json.error @exception.message
end
