# frozen_string_literal: true

module Store
  class CartItemsController < ApplicationController
    before_action :set_cart_item, only: %i[show update destroy]
    before_action :authenticate_user!

    # GET /cart_items
    def index
      @cart_items = CartItem.all
      cart_items = []
      @cart_items.each do |cart_item|
        item = display_cart_item(cart_item)
        cart_items << item
      end

      render_response(200, 'index rendered', :ok, cart_items)
    end

    # GET /cart_items/1
    def show
      render_response(200, 'show cart item', :ok, display_cart_item(@cart_item))
    end

    # POST /cart_items
    def create
      @cart_item = create_cart_item(params[:item_id], params[:cart_item][:quantity])

      if @cart_item.save
        render_response(201, 'cart item created', :created, display_cart_item(@cart_item))
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
        render_response(200, 'resource updated successfully', :ok, display_cart_item(@cart_item))
      else
        render_response(422, @cart_item.errors, :unprocessable_entity, display_cart_item(@cart_item))
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

    def display_cart_item(cart_item)
      image_url = (url_for(cart_item.item.images[0]) if cart_item.item.images.attached?)
      {
        cart_item_id: cart_item.id,
        item_id: cart_item.item_id,
        name: cart_item.item.title,
        description: cart_item.item.description,
        quantity: cart_item.quantity,
        image: image_url,
        price: cart_item.item.price
      }
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
end
