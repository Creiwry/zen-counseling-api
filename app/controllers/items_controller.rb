class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show update destroy ]
  before_action :authenticate_user!, except: %i[index show]
  before_action :check_if_admin, only: %i[create update destroy]

  # GET /items
  def index
    @items = Item.all

    render json: @items
  end

  # GET /items/1
  def show
    render json: @item
  end

  # POST /items
  def create
    @item = Item.new(item_params)

    if @item.save
      render json: @item, status: :created, location: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1
  def update
    if @item.update(item_params)
      render json: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy!
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  def check_if_admin
    return if current_user.admin

    render json: { status: 401, message: "You are not authorized to access this resource" }, status: 401
  end


  # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(:title, :description, :price, :stock, images:[])
  end
end
