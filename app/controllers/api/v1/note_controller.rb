class Api::V1::NoteController < Api::V1::BaseController
	before_action :find_own_note_by_id, only: [:update, :destroy]
	before_action only: [:create] do
		find_task_by_id(params[:task_id])
	end

  def create
		if @task.present?
			@note = @task.notes.create(allowed_params)

			if @note.invalid?
				render_errors(@note)
			else
				@note = eager_load_note(@note.id)
			end
		end
  end

  def update
		if @note.nil?
			render_empty_json
		end

		@note.update(allowed_params)

		if @note.invalid?
			render_errors(@note)
		else
			@note = eager_load_note(@note.id)
		end
  end

  def destroy
		if @note.nil?
			render_empty_json
		end

		@note.destroy
  end

	private

	def find_own_note_by_id
		@note = Note.where({ id: params[:id], user: @current_user }).first
	end

	def eager_load_note(id)
		Note.eager_load([:user]).where(id: id)[0]
	end

	def allowed_params
		params[:note].permit(:message).tap do |allowed_params|
			allowed_params[:user] = @current_user
		end if params.has_key?(:note)
	end
end