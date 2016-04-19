if @task.present?
  json.task do
    json.partial! 'task', locals: { task: @task}
  end
elsif @exception.present?
  json.error @exception.message
end
