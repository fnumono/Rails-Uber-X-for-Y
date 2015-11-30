#Base controller which inherited by every api controller
class Api::V1::BaseController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  respond_to :json

  def all_job_types
    types = Type.all
    render json: types
  end
end
