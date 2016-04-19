if @task_list.present?
  json.partial! 'create_update'
elsif @exception.present?
  json.error @exception.message
end
