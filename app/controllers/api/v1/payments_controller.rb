class Api::V1::PaymentsController < Api::V1::BaseController 
  before_action :authenticate_client!
 
  def index
    render json: current_client.payments
  end
end
