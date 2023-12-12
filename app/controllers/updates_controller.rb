class UpdatesController < ApplicationController
  before_action :set_update, only: %i[show update destroy]
  before_action :authenticate_user!, except: %i[show index]
  before_action :check_if_admin, only: %i[create update destroy]

  # GET /updates
  def index
    @updates = Update.all

    updates_array = []

    @updates.each do |update|
      updates_array << update.as_json.merge(image: url_for(update.image))
    end
    render_response(200, 'index rendered', :ok, updates_array)
  end

  # GET /updates/1
  def show
    render_response(200, 'show update', :ok, @update.as_json.merge(image: url_for(@update.image)))
  end

  # POST /updates
  def create
    @update = Update.new(update_params)
    @update.admin = current_user

    if @update.save
      render_response(201, 'update created', :created, @update)
    else
      render_response(422, @update.errors, :unprocessable_entity, nil)
    end
  end

  # PATCH/PUT /updates/1
  def update
    if @update.update(update_params)
      render_response(200, 'resource updated successfully', :ok, @update)
    else
      render_response(422, @update.errors, :unprocessable_entity, @update)
    end
  end

  # DELETE /updates/1
  def destroy
    @update.destroy!

    render_response(200, 'resource deleted successfully', :ok, nil)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_update
    @update = Update.find(params[:id])
  end

  def check_if_admin
    return if current_user.admin

    render_response(401, 'You are not authorized to access this resource', :unauthorized, nil)
  end

  # Only allow a list of trusted parameters through.
  def update_params
    params.require(:update).permit(:title, :content, :image, :admin_id)
  end
end
