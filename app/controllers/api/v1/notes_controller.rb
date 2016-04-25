class Api::V1::NotesController < Api::V1::BaseController
	before_filter only: [:update, :destroy] do
		find_note_by_id(params[:id])
	end
	before_filter only: [:create] do
		find_task_by_id(params[:task_id])
	end

  def create
		note = @current_user.notes.create(allowed_params)

		if note.invalid?
			render_errors(note)
		else
			@note = Note.eager_load_note(note.id)
		end
  end

  def update
		@note.update(allowed_params)

		if @note.invalid?
			render_errors(@note)
		else
			@note = Note.eager_load_note(@note.id)
		end
  end

  def destroy
		@note.destroy
  end

	private

	def allowed_params
		params[:note].permit(:message).tap do |allowed_params|
			allowed_params[:task_id] = params[:task]

		end if params.has_key?(:note)
	end
end
