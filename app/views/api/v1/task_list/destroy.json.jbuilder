if @task_list.present?
  json.task_list do
    json.partial! 'task_list', locals: { task_list: @task_list}
  end
elsif @exception.present?
  json.error @exception.message
end
