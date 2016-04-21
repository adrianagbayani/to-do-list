class Api::V1::TasksController < Api::V1::BaseController
	before_action only: [:update, :destroy, :complete] do
		find_task_by_id(params[:id])
	end

	before_action only: [:create] do
		find_task_list_by_id(params[:task_list_id])
	end

  def show
		@task = Task.eager_load_task(params[:id])

		if @task.nil?
			render_empty_json
		end
  end

  def create
    if @task_list.present?
      @task = @task_list.tasks.create(allowed_params)

			if @task.invalid?
				render_errors(@task)
			else
				@task = Task.eager_load_task(@task.id)
			end
    end
  end

  def update
		if @task.nil?
			render_empty_json
		else
			@task.update(allowed_params)

			if @task.invalid?
				render_errors(@task)
			else
				@task = Task.eager_load_task(@task.id)
			end
		end
  end

  def destroy
		if @task.nil?
			render_empty_json
		else
			@task.destroy
		end
  end

	def complete
		if @task.nil?
			render_empty_json
		else
			@task.complete_task
		end
	end

  private

  def allowed_params
    params[:task].permit(:title).tap do |allowed_params|
			allowed_params[:user] = @current_user

      if params[:task][:due_date].present?
        allowed_params[:due_date] = Date.strptime(params[:task][:due_date], "%m/%d/%Y")
      end
    end if params.has_key?(:task)
  end
end
