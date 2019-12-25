class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :set_task_info, only: [:show, :edit, :update, :destroy]
  before_action :check_task_belonging, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = current_user.tasks
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      flash[:success] = 'Task が正常に投稿されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task が投稿されませんでした'
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy

    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
  end

  private

  def set_task_info
    @task = Task.find(params[:id])
  end

  def check_task_belonging
    unless @task.user_id == current_user.id
      flash[:rejection] = 'タスクに関する権限がありません'
      redirect_to tasks_url
    end
  end

  #Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
end
