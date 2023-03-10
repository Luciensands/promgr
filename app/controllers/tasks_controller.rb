class TasksController < ApplicationController
  def index
    @tasks = policy_scope(Task)
    @user = current_user
    @meetings = Meeting.all
    @meeting = Meeting.new
    @users = User.all
  end

  def new
    @task = Task.new
    @users = User.all
    # render partial: 'tasks/addtask', locals: { task: @task }
    authorize @task
  end

  def create
    @task = Task.new(task_params)
    authorize @task

    if @task.save
      # SlackClient.client.chat_postMessage(channel: '#general', blocks: BuildSlackMessageService.new(@task).call)
      message = BuildAddTaskMessageService.new(@task).call
      SendSlackMessageService.new(channel: '#tasks-notifications', message: message).call
      redirect_to users_path, notice: "Added task notification sent on Slack channel #tasks-notifications."
    else
      render "users/dashboard", status: :unprocessable_entity, locals: { timesheet_new: Timesheet.new }
    end
  end

  def edit
    @task = Task.find(params[:id])
    authorize @task
  end

  def update
    @task = Task.find(params[:id])
    authorize @task

    if @task.update(task_params)
      redirect_to tasks_path, notice: "Task done notification sent on Slack channel #tasks-notifications."
    else
      render "tasks/edittaskform", status: :unprocessable_entity
    end

    if @task.status == 'done'
      message = BuildTaskDoneMessageService.new(@task).call
      SendSlackMessageService.new(channel: '#tasks-notifications', message: message).call
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    authorize @task
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:task_title, :description, :status, :due_date, user_ids: [])
  end
end
