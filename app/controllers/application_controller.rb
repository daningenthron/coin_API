class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  before_action :authenticate
  
  private

  def authenticate
    authenticate_api_key || deny_request
  end

  def api_key
    request.headers['X-Api-Key']
  end

  def authenticate_api_key
    @auth_key = ApiKey.find_by(key_str: api_key)
  end

  def auth_key
    @auth_key
  end

  def deny_request
    if api_key
      render json: "#{api_key} is not a valid API key", status: 401
    else
      render json: "Please include a valid API key in the headers", status: 401
    end
  end
end
