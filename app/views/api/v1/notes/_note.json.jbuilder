json.note do
	json.id note.id
	json.message note.message
	json.partial! 'api/v1/users/user', locals: { user: note.user }
end
