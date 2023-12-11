class Store::CartsController < ApplicationController
  before_action :authenticate_user!, only: %i[ show update ]
  # GET /carts
  # def index
  #   @carts = Cart.all

  #   render json: @carts
  # end

  # GET /car
  def show
    @cart = Cart.find_by(user: current_user)

    render json: { cart: @cart, cart_items: @cart.cart_items_display }
  end

  # POST /carts
  # def create
  #   @cart = Cart.new(cart_params)

  #   if @cart.save
  #     render json: @cart, status: :created, location: @cart
  #   else
  #     render json: @cart.errors, status: :unprocessable_entity
  #   end
  # end

  # PATCH/PUT /carts/1
  # def update
  #   if @cart.update(cart_params)
  #     render json: @cart
  #   else
  #     render json: @cart.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /carts/1
  # def destroy
  #   @cart.destroy!
  # end

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
