class UsersController < ApplicationController
    before_action :check_if_admin, only: %i[index]
  
    # GET /updates
    def index
      @users = User.where.not(id: current_user.id)
  
      render json: @users
    end
  
  
    def check_if_admin
      return if current_user.admin
  
      render json: { status: 401, message: "You are not authorized to access this resource" }, status: 401
    end
   
  end
  