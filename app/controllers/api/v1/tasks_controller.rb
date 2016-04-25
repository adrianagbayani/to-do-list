class Api::V1::TasksController < Api::V1::BaseController
	before_filter only: [:update, :destroy, :complete] do
		find_task_by_id(params[:id])
	end

	before_filter only: [:create] do
		find_task_list_by_id(params[:task_list_id])
	end

  def show
		@task = Task.eager_load_task(params[:id])

		if @task.nil?
			render_empty_json
		end
  end

  def create
    task = @current_user.tasks.create(allowed_params)

		if task.invalid?
			render_errors(task)
		else
			@task = Task.eager_load_task(task.id)
		end
  end

  def update
		@task.update(allowed_params)

		if @task.invalid?
			render_errors(@task)
		else
			@task = Task.eager_load_task(@task.id)
		end
  end

  def destroy
		@task.destroy
  end

	def complete
		@task.complete_task
	end

  private

  def allowed_params
    params[:task].permit(:title, :due_date).tap do |allowed_params|
			allowed_params[:task_list_id] = params[:task_list_id]

      if allowed_params[:due_date].present?
        allowed_params[:due_date] = Date.strptime(allowed_params[:due_date], "%m/%d/%Y")
      end
    end if params.has_key?(:task)
  end
end
