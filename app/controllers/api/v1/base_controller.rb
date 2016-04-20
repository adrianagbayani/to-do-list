class Api::V1::BaseController < ApplicationController
	protected
	def find_task_by_id(id)
		@task = Task.find_by_id(id)
	end

  def find_task_list_by_id(id)
    @task_list = TaskList.find_by_id(id)
  end

	def find_own_task_by_id(id)
		@task = Task.where({ id: id, user: @current_user }).first
	end

  def find_own_task_list_by_id(id)
    @task_list = TaskList.where({ id: id, user: @current_user }).first
  end
end
