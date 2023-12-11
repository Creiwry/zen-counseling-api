class Store::CartsController < ApplicationController
  before_action :authenticate_user!, only: %i[ show update ]
  # GET /car
  def show
    @cart = Cart.find_by(user: current_user)

    render json: { cart: @cart, cart_items: @cart.cart_items_display }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cart
    @cart = Cart.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def cart_params
    params.require(:cart).permit(:user_id)
  end
end
