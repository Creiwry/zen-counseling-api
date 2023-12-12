class UsersController < ApplicationController
  before_action :check_if_admin, only: %i[index]

  # GET /updates
  def index
    @users = User.where.not(id: current_user.id)

    render_response(200, 'index users successful', :ok, @users)
  end

  def check_if_admin
    return if current_user.admin

    render_response(401, 'You are not authorized to access this resource', :unauthorized, nil)
  end
end
