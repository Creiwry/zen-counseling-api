class Store::CartItemsController < ApplicationController
  before_action :set_cart_item, only: %i[ show update destroy ]
  before_action :authenticate_user!

  # GET /cart_items
  def index
    @cart_items = CartItem.all

    render json: @cart_items
  end

  # GET /cart_items/1
  def show
    render json: @cart_item
  end

  # POST /cart_items
  def create
    if current_user.cart_items.find_by(item_id: params[:item_id])
      @cart_item = current_user.cart_items.find_by(item_id: params[:item_id])
      @cart_item.update(quantity: params[:cart_item][:quantity])
    else
      @cart_item = CartItem.new(
        cart: current_user.cart,
        item_id: params[:item_id],
        quantity: params[:cart_item][:quantity]
      )
    end

    if @cart_item.save
      render json: @cart_item, status: :created
    else
      render json: @cart_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cart_items/1
  def update
    if params[:cart_item][:quantity].to_i.zero?
      @cart_item.destroy!
      render json: { status: :no_content }, status: :no_content
    elsif @cart_item.update(cart_item_params)
      render json: @cart_item
    else
      render json: @cart_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cart_items/1
  def destroy
    @cart_item.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cart_item
    @cart_item = CartItem.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def cart_item_params
    params.require(:cart_item).permit(:cart_id, :item_id, :quantity)
  end
end
