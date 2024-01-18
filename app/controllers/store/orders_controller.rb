# frozen_string_literal: true

module Store
  class OrdersController < ApplicationController
    before_action :set_order, only: %i[show update destroy]
    before_action :authenticate_user!

    # GET /orders
    def index
      unless current_user.admin || current_user.id == params[:user_id].to_i
        render_response(401, 'You are not authorized to access this resource', :unauthorized, nil)
        return
      end

      @orders = Order.find_by(user_id: params[:user_id])

      render_response(200, 'index rendered', :ok, @orders)
    end

    def previous_order
      if current_user.orders.last
        order = current_user.orders.last
        data = {
          previous_order: true,
          address: {
            country: order.country,
            city: order.city,
            street_address: order.street_address,
            zip_code: order.zip_code
          }
        }
        render_response(200, 'address found', :ok, data)
      else
        render_response(200, 'no former order', :ok, { previous_order: false })
      end
    end

    # GET /orders/1
    def show
      unless current_user.admin || @order.user_id == current_user.id
        render_response(401, 'You are not authorized to access this resource', :unauthorized, nil)
        return
      end

      render_response(200, 'show order', :ok, @order)
    end

    # POST /orders
    def create
      order = current_user.cart.create_order(params[:order][:address])
      if order[:success] == true
        render_response(201, 'Order created', :created, order[:order])
      else
        response_message = current_user.cart.create_order(params[:order][:address]).status
        render_response(424, response_message, :failed_dependency, @order)
      end
    end

    # PATCH/PUT /orders/1
    def update
      unless current_user.admin || @order.user_id == params[:user_id]
        render_response(401, 'You are not authorized to access this resource', :unauthorized, nil)
        return
      end
      if @order.update(order_params)
        render_response(200, 'resource updated successfully', :ok, @order)
      else
        render_response(422, @order.errors, :unprocessable_entity, @order)
      end
    end

    # DELETE /orders/1
    def destroy
      @order.destroy!
      render_response(200, 'resource deleted successfully', :ok, nil)
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:user_id, :stripe_customer_id, :total, :address, :status)
    end
  end
end
