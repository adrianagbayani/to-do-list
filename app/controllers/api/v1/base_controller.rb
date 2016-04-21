class Api::V1::BaseController < ApplicationController

	protected

	def find_task_by_id(id)
		@task = Task.find_by_id(id)
	end

  def find_task_list_by_id(id)
    @task_list = TaskList.find_by_id(id)
  end

	def find_note_by_id(id)
		@note = Note.find_by_id(id)
	end

	def render_errors(object)
		render json: { errors: object.errors },
			status: :unprocessable_entity
	end

	def render_empty_json
		render json: { errors: 'Object not found' },
			status: :unprocessable_entity and return
	end
end
