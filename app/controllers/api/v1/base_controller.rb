#Base controller which inherited by every api controller
class Api::V1::BaseController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  respond_to :json

  before_action :authenticate_client!, only: [:test]
  # skip_before_filter  :verify_authenticity_token    # disable csrf token verify skips the :verify_authenticity_token filter.
  # before_filter :cors_set_headers
  #
  # include Api::V1::Authenticable
  # include SlackModule
  # before_action :authenticate_with_token! , except: [:cors_preflight]
  # rescue_from ::Exception, with: :record_not_found
  #
  # def record_not_found exception
  #   render json: { message: exception.message.gsub(/ \[.*\]/, '')}, status: 404
  # end
  #
  # # for pre-allowing all request.
  # def cors_preflight
  #   if request.method == 'OPTIONS'
  #     headers['Access-Control-Allow-Origin'] = '*'
  #     headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE'
  #     render text: '', content_type: 'text/plain'
  #   end
  # end
  #
  # # for cross-domain allowing.
  # def cors_set_headers
  #   headers['Access-Control-Allow-Origin'] = '*'
  #   headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, PATCH, OPTIONS, HEAD'
  #   headers['Access-Control-Allow-Headers'] = '*, x-requested-with, Content-Type, If-Modified-Since, If-None-Match, Authorization'
  # end

  def test
    render json: {message: 'test ok!'}
  end


  protected
  # def authenticate
  #   authenticate_token || render_unauthorized
  # end
  #
  # def authenticate_token
  #   authenticate_with_http_token do |token, options|
  #     @api_user = User.find_by(access_token: token)
  #   end
  # end
  #
  # def render_unauthorized
  #   self.headers['WWW-Authenticate'] = 'Token realm="Application"'
  #   render json: {response_message: 'Bad credentials'}, status: 401
  # end

  # def find_car
  #   render json: {alert: 'Not found car'}, status: 404  unless @car = Car.find_by_id(params[:id])
  # end


end
