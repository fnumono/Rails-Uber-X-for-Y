#Base controller which inherited by every api controller
class Api::V1::BaseController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  respond_to :json

  def all_job_types
    types = Type.all
    render json: types
  end

  protected
  	def authenticate_agent!
  		if params[:agent] == 'client'
  			authenticate_client!
  		elsif params[:agent] == 'provider'
  			authenticate_provider!
  		else
  			render json: { error: 'only client and provider can access'}, status: 401	
  		end
  	end

    def current_agent
      agent = current_client if client_signed_in?
      agent = current_provider if provider_signed_in?
      agent
    end
end
