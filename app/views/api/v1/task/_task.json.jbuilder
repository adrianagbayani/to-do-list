json.task do
	json.id task.id
	json.title task.title
	json.due_date task.due_date
	json.partial! 'api/v1/user/user', locals: { user: task.user }
	json.notes do
		json.partial! 'api/v1/note/note', collection: task.notes, as: :note
	end
end
