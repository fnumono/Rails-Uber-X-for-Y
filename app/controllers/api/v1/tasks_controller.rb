#Base controller which inherited by every api controller
class Api::V1::TasksController < Api::V1::BaseController  
  before_action :authenticate_agent! , only: [:index_mytasks,  :upload]
  before_action :authenticate_client!, only: [:create, :destroy, :update]
  before_action :authenticate_provider!, only: [:accept, :complete]
  before_action :find_mytask!, only: [:destroy, :upload, :update, :complete]
  before_action :find_task!, only: [:show, :accept]
 
  def index
    params[:offset] = 0 if params[:offset].blank?
    if params[:limit].blank?
      tasks = Task.all
    else
      tasks = Task.order(status: :desc, datetime: :desc).limit(params[:limit]).offset(params[:offset])
    end      
    render json: tasks
  end

  def show    
    render json: @task
  end

  def index_mytasks
    params[:offset] = 0 if params[:offset].blank?
    if params[:limit].blank?
      tasks = current_agent.tasks.order(status: :desc, datetime: :desc)
    else 
      tasks = current_agent.tasks.order(status: :desc, datetime: :desc).limit(params[:limit]).offset(params[:offset])
    end
    render json: tasks
  end

  def create
    tparams = params[:task]
    if tparams[:datetime].blank?
      render json: {alert: 'Date and Time format is not proper.'}, status: 400 and return
    end

    if Task.find_by_title_and_datetime_and_address(tparams[:title],tparams[:datetime],tparams[:address])
      if !params[:force]
        render json: {alert: 'Same task already has been submitted.'}, status: 422 and return
      end
    end

    # zoomoffice = ZoomOffice.find_by(id: tparams[:zoomoffice])
    #   if zoomoffice.nil?
    #     render json: { alert: 'Select your ZoomOffice exactly.'}, status: 403 and return
    #   end

    task = Task.new(task_params)
    # task.zoom_office = zoomoffice
    task.client = current_client
    task.status = 'open'
      if task.save        
        render json: task, status: :created
      else
        render json: {errors: task.errors}, status: 401
      end
  end

  def update
    if params[:task][:datetime].blank?
      render json: {alert: 'Date and Time format is not proper.'}, status: 400 and return
    end

    if @task.update(update_task_params)
      render json: @task
    else
      render json: {errors: @task.errors.messages}, status: 403
    end
  end


  def destroy
    task = @task.destroy
    if task
      render json: {title: task.title}
    else 
      render json: {errors: @task.errors.messages}, status: 422
    end    
  end


  def upload
    upload = @task.task_uploads.new(task_upload_params)

    if upload.save
      render json: {thumbUrl: upload.uploadThumbUrl, uploadUrl: upload.uploadUrl}, status: :created
    else
      render json: {errors: upload.errors}, status: 422
    end
  end

  def accept    
    if @task.provider.nil?
      if !(current_provider.setting.types.exist?(@task.type_id))
        render json: {errors: 'You can\'t accept ' + @task.type.name + ' tasks.' }, status: 403 and return
      end

      @task.provider = current_provider
      if @task.save
        render json: @task
      else
        render json: {errors: 'Sorry, the task is invalid'}, status: 500
      end
    elsif @task.provider == current_provider
      render json: {errors: 'You are already awarded to this task. Please check "my jobs" page'}, status: 400
    else  
      render json: {errors: 'The task was already accepted by other service provider'}, status: 403  
    end
  end

  def complete
    if params[:status].nil?
      params[:status] = 'close'
    end

    params[:usedHour] = params[:usedHour].blank? ? 0 : params[:usedHour].to_f.abs
    params[:usedEscrow] = params[:usedEscrow].blank? ? 0 : params[:usedEscrow].to_f.abs
    # @task.client.escrow_hour.hoursavail -= usedHour
    # @task.client.escrow_hour.hoursused += usedHour
    # @task.client.escrow_hour.escrowavail -= usedEscrow
    # @task.client.escrow_hour.escrowused += usedEscrow   

    begin
      ActiveRecord::Base.transaction do      
        # @task.client.escrow_hour.save!
        @task.update!(complete_task_params)
        raise ActiveRecord::RecordInvalid
      end
      render json: @task
    rescue
      render json: {errors: "The task can't be completed."}, status: 403
    end
  end

  private
    def find_mytask!
      begin
        @task = current_agent.tasks.find(params[:id])
      rescue
        render json: {errors: 'There is no task you requested'}, status: 404      
      end
    end

    def find_task!
      begin
        @task = Task.find(params[:id])
      rescue
        render json: {errors: 'There is no task you requested'}, status: 404       
      end
    end

    def task_params      
        params.require(:task).permit(:title, :datetime, :address, :addrlat, :addrlng, :contact, :type_id, \
                  :details, :escrowable, :zoom_office_id, task_uploads_attributes:[:id, :upload])      
    end

    def update_task_params      
        params.require(:task).permit(:title, :datetime, :address,  :addrlat, :addrlng, :contact, :type_id, \
                  :details, :escrowable, :zoom_office_id, task_uploads_attributes:[:id, :upload])      
    end

    def complete_task_params
      params.permit(:usedHour, :usedEscrow, :status, task_uploads_attributes:[:id, :upload])
    end

    def task_upload_params
      params.permit(:upload)
    end

        
end
