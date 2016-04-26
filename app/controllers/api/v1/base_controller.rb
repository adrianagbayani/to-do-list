class Api::V1::BaseController < ApplicationController

	protected

  def authentication_controller?
    false
  end

	def find_task_by_id(id)
		@task = Task.find_by_id(id)

		if @task.nil?
			render_empty_json
		end
	end

  def find_task_list_by_id(id)
    @task_list = TaskList.find_by_id(id)

		if @task_list.nil?
			render_empty_json
		end
  end

	def find_note_by_id(id)
		@note = Note.find_by_id(id)

		if @note.nil?
			render_empty_json
		end
	end

	def render_errors(object)
		render json: { errors: object.errors },
			status: :unprocessable_entity and return
	end

	def render_empty_json
		render json: { errors: 'Object not found' },
			status: :unprocessable_entity and return
	end
end
