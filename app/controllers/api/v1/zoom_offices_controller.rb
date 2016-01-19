#Base controller which inherited by every api controller
class Api::V1::ZoomOfficesController < Api::V1::BaseController  
 
  def index
    render json: ZoomOffice.all
  end
end
