class Store::CartItemsController < ApplicationController
  before_action :set_cart_item, only: %i[ show update destroy ]
  before_action :authenticate_user!

  # GET /cart_items
  def index
    @cart_items = CartItem.all

    render_response(200, 'index rendered', :ok, @cart_items)
  end

  # GET /cart_items/1
  def show
    render_response(200, 'show cart item', :ok, @cart_item)
  end

  # POST /cart_items
  def create
    @cart_item = create_cart_item(params[:item_id], params[:cart_item][:quantity])

    if @cart_item.save
      render_response(201, 'cart item created', :created, @cart_item)
    else
      render_response(422, @cart_item.errors, :unprocessable_entity, nil)
    end
  end

  # PATCH/PUT /cart_items/1
  def update
    if params[:cart_item][:quantity].to_i.zero?
      @cart_item.destroy!
      render_response(200, 'resource deleted successfully', :ok, nil)
    elsif @cart_item.update(cart_item_params)
      render_response(200, 'resource updated successfully', :ok, @cart_item)
    else
      render_response(422, @cart_item.errors, :unprocessable_entity, @cart_item)
    end
  end

  # DELETE /cart_items/1
  def destroy
    @cart_item.destroy!
    render_response(200, 'resource deleted successfully', :ok, nil)
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

  def create_cart_item(item_id, cart_item_quantity)
    if current_user.cart_items.find_by(item_id:)
      cart_item = current_user.cart_items.find_by(item_id:)
      cart_item.update(quantity: cart_item_quantity)
    else
      cart_item = CartItem.new(cart: current_user.cart, item_id:, quantity: cart_item_quantity)
    end
    cart_item
  end
end
