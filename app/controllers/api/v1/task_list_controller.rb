class Api::V1::TaskListController < Api::V1::BaseController
  before_action only: [:update, :destroy] do
  	find_own_task_list_by_id(params[:id])
  end

  def index
    @task_lists = TaskList.all
  end

  def create
    @task_list = TaskList.create(allowed_params)

		if @task_list.invalid?
			render_errors(@task_list)
		else
			@task_list = eager_load_task_list(@task_list.id)
		end
  end

  def update
		if @task_list.nil?
			render_empty_json
		end

    @task_list.update(allowed_params)

		if @task_list.invalid?
			render_errors(@task_list)
		else
			@task_list = eager_load_task_list(@task_list.id)
		end
  end

  def destroy
		if @task_list.nil?
			render_empty_json
		end

    @task_list.destroy
  end

  def show
		@task_list = eager_load_task_list(params[:id])

		if @task_list.nil?
			render_empty_json
		end
  end

  private

	def eager_load_task_list(id)
		TaskList.eager_load([:user, :tasks => [:user, :notes => :user]]).where(id: id)[0]
	end

  def allowed_params
    params.require(:task_list).permit(:name).tap do |allowed_params|
			allowed_params[:user] = @current_user
    end if params.has_key?(:task_list)
  end

end
