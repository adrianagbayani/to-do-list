json.task do
	json.id task.id
	json.title task.title
	json.due_date task.due_date
	json.complete task.complete
	json.partial! 'api/v1/users/user', locals: { user: task.user }
	json.notes do
		json.partial! 'api/v1/notes/note', collection: task.notes, as: :note
	end
end
