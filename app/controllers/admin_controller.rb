class AdminController < ApplicationController
  before_action :verify_admin

  def index
  end

  def user_permissions
    @roles = Role.global_role_names
    @users = User.all.paginate(:page => params[:page], :per_page => 100).preload(:roles)
  end

  def update_permissions
    if params["permitted"] == 'true'
      if params["role"] == 'developer'
        render :plain => "you must be a developer", :status => :forbidden
        return
      end
      User.find(params["user_id"]).add_role params["role"]
    else
      User.find(params["user_id"]).remove_role params["role"]
    end

    render :plain => "success", :status => :accepted
  end
end
