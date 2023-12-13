class Store::CartsController < ApplicationController
  before_action :authenticate_user!, only: %i[ show update ]
  # GET /car
  def show
    @cart = Cart.find_by(user: current_user)

    render_response(200, 'get cart successful', :ok, { cart_items: cart_items_display })
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cart
    @cart = Cart.find(params[:id])
  end

  def cart_items_display
    display_items_array = []
    current_user.cart.cart_items.each do |cart_item|
      if cart_item.item.images.attached?
        puts "image attached"
        puts cart_item.item.images[0]
        image_url = url_for(cart_item.item.images[0])
      else
        image_url = nil
      end
      item = {
        cart_item_id: cart_item.id,
        item_id: cart_item.item_id,
        name: cart_item.item.title,
        description: cart_item.item.description,
        quantity: cart_item.quantity,
        image: image_url,
        total_price: cart_item.quantity * cart_item.item.price
      }
      display_items_array << item
    end
    display_items_array
  end
  # Only allow a list of trusted parameters through.
  def cart_params
    params.require(:cart).permit(:user_id)
  end
end
