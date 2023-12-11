class CurrentUserController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: UserSerializer.new(current_user).serializable_hash[:data][:attributes], status: :ok
  end

  def is_admin
    render json: { admin: current_user.admin }, status: :ok 
  end
end
