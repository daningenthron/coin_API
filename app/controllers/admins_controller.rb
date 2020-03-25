class AdminsController < ApplicationController
  before_action :find_admin, only: [:show, :update, :destroy]

  def index
    @admins = Admin.all
    json_response(@admins)
  end

  def show
    json_response(@admin)
  end

  def create
    @admin = Admin.create!(admin_params)
    json_response(@admin, :created)
  end

  def update
    @admin.update(admin_params)
    if @admin.save 
      head :no_content
    else
      json_response('Update failed', 422)
    end
  end

  def destroy
    @admin.destroy
    head :no_content
  end

  private

  def admin_params
    params.permit(:name, :email)
  end

  def find_admin
    @admin = Admin.find(params[:id])
  end
end
