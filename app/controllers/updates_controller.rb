class UpdatesController < ApplicationController
  before_action :set_update, only: %i[ show update destroy ]

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

    # Only allow a list of trusted parameters through.
    def update_params
      params.require(:update).permit(:title, :content, :user_id, :image)
    end
end
