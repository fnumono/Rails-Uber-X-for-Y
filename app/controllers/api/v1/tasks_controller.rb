#Base controller which inherited by every api controller
class Api::V1::TasksController < Api::V1::BaseController  
  before_action :authenticate_agent! , only: [:index_mytasks, :update, :upload]
  before_action :authenticate_client!, only: [:create, :destroy]
  before_action :find_mytask!, only: [:destroy]
 
  def index
    tasks = Task.all
    render json: tasks
  end

  def show
    task = Task.find(params[:id])
    render json: task
  end

  def index_mytasks
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

    zoomcity = ZoomCity.find_by(longName: tparams[:longCity])
      if zoomcity.nil?
        render json: { alert: 'Sorry, We have not zoom office in ' + tparams[:longCity] + '.'}, status: 403 and return
      end

    task = Task.new(task_params)
    task.zoom_city = zoomcity
    task.client = current_client
    task.status = 'open'
      if task.save
        render json: task, status: :created
      else
        render json: {errors: task.errors}, status: 401
      end
  end  

  def update
    task = current_agent.tasks.find(params[:id])
    if task.update(update_task_params)
      render json: task
    else
      render json: {error: task.errors.messages}, status: 403
    end
  end

  def upload
    task = current_agent.tasks.find(params[:id])
    upload = task.task_uploads.new(task_upload_params)

    if upload.save
      render json: {thumbUrl: upload.uploadThumbUrl}, status: :created
    else
      render json: {errors: upload.errors}, status: 422
    end
  end

  def destroy
    task = @task.destroy
    if task
      render json: {title: task.title}
    else 
      render json: {error: @task.errors.messages}, status: 422
    end      
    
  end

  private
    def find_mytask!
      @task = current_agent.tasks.find(params[:id])
        if @task.nil?
          render json: {error: 'There is no task you requested'}, status: 403       
        end
    end

    def task_params
      if client_signed_in?
        params.require(:task).permit(:title, :datetime, :address, :contact, :type_id, \
                  :details, :escrowable, :addrlat, :addrlng)
      elsif provider_signed_in?
        params.require(:task).permit(:usedHour, :usedEscrow, :status)
      end
    end

    def update_task_params
      if client_signed_in?
        params.permit(:title, :datetime, :address,  :addrlat, :addrlng, :contact, :type_id, \
                  :details, :escrowable, task_uploads_attributes:[:id, :upload])
      elsif provider_signed_in?
        params.permit(:usedHour, :usedEscrow, :status)
      end  
    end

    def task_upload_params
      params.permit(:upload)
    end
end
