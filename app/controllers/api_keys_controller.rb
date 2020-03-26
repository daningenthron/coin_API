require 'pry'

class ApiKeysController < ApplicationController
  before_action :find_api_key, only: [:update, :destroy]

  def index
    @api_keys = ApiKey.all
    json_response(@api_keys)
  end

  def show
    @api_key = ApiKey.find(params[:id])
    render json: @api_key, include: ['txns']
  end

  def create
    @api_key = ApiKey.create!(api_key_params.merge(key_str: create_key))
    add_admin if api_key_params['admin'] == 'true'
    json_response(@api_key, :created)
  end

  def update
    add_admin if api_key_params['admin'] == 'true' && @api_key.admin == 'false'
    @api_key.update(api_key_params)
    head :no_content
  end

  def destroy
    @api_key.destroy
    head :no_content
  end

  private

  def create_key
    random_key = SecureRandom.hex(3)
    create_key if ApiKey.exists?(key_str: random_key)
    random_key
  end

  def api_key_params
    params.permit(:email, :id, :key_str, :admin)
  end

  def find_api_key
    @api_key = ApiKey.find(params[:id])
  end

  def add_admin
    Admin.create(email: @api_key.email)
  end
end
