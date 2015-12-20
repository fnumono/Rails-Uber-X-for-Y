#Base controller which inherited by every api controller
class Api::V1::TasksController < Api::V1::BaseController  
  before_action :authenticate_agent! , only: [:index]
  before_action :authenticate_client!, only: [:create]
 
  def index
    tasks = current_agent.tasks
    render json: tasks
  end

  def create
    tparams = params[:task]
    if Task.find_by_title_and_datetime_and_address(tparams[:title],tparams[:datetime],tparams[:address])
      if !params[:force]
        render json: {alert: 'Same task already has been submitted.'}, status: 422 and return
      end
    end
    task = Task.new(task_params)
    task.client = current_client
    task.status = 'submitted'
      if task.save
        render json: {task: task}, status: :ok
      else
        render json: {errors: task.errors}, status: 401
      end
  end

  def show
    task = current_agent.tasks.find(params[:id])
    render json: {task: task}
  end

  def update
    task = current_agent.tasks.find(params[:id])
    if task.update(task_params)
      render json: {task: task}
    else
      render json: {error: task.errors.messages}, status: 403
    end
  end

  private    
    def task_params
      if client_signed_in?
        params.require(:task).permit(:title, :datetime, :address, :contact, :types, \
                  :details, :escrowable, :usedHour, :usedEscrow, :task_uploads_attributes[:id, :upload])
      elsif provider_signed_in?
        params.require(:task).permit(:usedHour, :usedEscrow, :task_uploads_attributes[:id, :upload])
      end  
    end
end
