class Api::V1::TaskController < ApplicationController
  def view
    begin
      @task = Task.find(params[:id])
    rescue ActiveRecord::RecordNotFound => @exception

    end
  end

  def create
    task_list = TaskList.find(params[:task_list_id])

    if task_list.present?
      @task = task_list.tasks.create(allowed_params)
    end
  end

  def update
    begin
      @task = Task.find(params[:id])

      @task.update(allowed_params)
    rescue ActiveRecord::RecordNotFound => @exception

    end
  end

  def destroy
    begin
      @task = Task.find(params[:id])

      @task.destroy
    rescue ActiveRecord::RecordNotFound => @exception

    end
  end

  private

  def allowed_params
    params[:task].permit(:title).tap do |allowed_params|
      if params[:task][:due_date].present?
        allowed_params[:due_date] = Date.strptime(params[:task][:due_date], "%m/%d/%Y")
      end
    end
  end
end
