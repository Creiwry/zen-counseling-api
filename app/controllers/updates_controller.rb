class UpdatesController < ApplicationController
  before_action :set_update, only: %i[ show update destroy ]
  before_action :authenticate_user!, except: %i[show index]
  before_action :check_if_admin, only: %i[create update destroy]

  # GET /updates
  def index
    @updates = Update.all

    render json: @updates
  end

  # GET /updates/1
  def show
    render json: @update
  end

  # POST /updates
  def create
    @update = Update.new(update_params)
    @update.admin = current_user

    if @update.save
      render json: @update, status: :created, location: @update
    else
      render json: @update.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /updates/1
  def update
    if @update.update(update_params)
      render json: @update
    else
      render json: @update.errors, status: :unprocessable_entity
    end
  end

  # DELETE /updates/1
  def destroy
    @update.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_update
    @update = Update.find(params[:id])
  end

  def check_if_admin
    return if current_user.admin

    render json: { status: 401, message: "You are not authorized to access this resource" }, status: 401
  end
  # Only allow a list of trusted parameters through.
  def update_params
    params.require(:update).permit(:title, :content, :image, :admin_id)
  end
end
