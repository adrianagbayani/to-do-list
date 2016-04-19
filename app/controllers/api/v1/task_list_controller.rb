class Api::V1::TaskListController < ApplicationController
  def index
    @task_lists = TaskList.all
  end

  def create
    @task_list = TaskList.create(allowed_params)
  end

  def update
    begin
      @task_list = TaskList.find(params[:id])
      @task_list.update(allowed_params)
    rescue ActiveRecord::RecordNotFound => ex
      @exception = ex
    end
  end

  def destroy
    begin
      @task_list = TaskList.find(params[:id])
      @task_list.destroy
    rescue ActiveRecord::RecordNotFound => ex
      @exception = ex
    end
  end

  def view
    begin
      @task_list = TaskList.find(params[:id])
    rescue ActiveRecord::RecordNotFound => ex
      @exception = ex
    end
  end

  private

  def allowed_params
    params[:task_list].permit(:name)
  end
end
