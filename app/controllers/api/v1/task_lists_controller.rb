class Api::V1::TaskListsController < Api::V1::BaseController
  before_action only: [:update, :destroy] do
  	find_task_list_by_id(params[:id])
  end

  def index
    @task_lists = TaskList.all
  end

  def create
    @task_list = @current_user.task_lists.create(allowed_params)

		if @task_list.invalid?
			render_errors(@task_list)
		else
			@task_list = TaskList.eager_load_task_list(@task_list.id)
		end
  end

  def update
		if @task_list.nil?
			render_empty_json
		else
			@task_list.update(allowed_params)

			if @task_list.invalid?
				render_errors(@task_list)
			else
				@task_list = TaskList.eager_load_task_list(@task_list.id)
			end
		end
  end

  def destroy
		if @task_list.nil?
			render_empty_json
		else
	    @task_list.destroy
		end
  end

  def show
		@task_list = TaskList.eager_load_task_list(params[:id])

		if @task_list.nil?
			render_empty_json
		end
  end

  private

  def allowed_params
    params[:task_list].permit(:name) if params.has_key?(:task_list)
  end
end
