class Store::OrdersController < ApplicationController
  before_action :set_order, only: %i[ show update destroy ]
  before_action :authenticate_user!

  # GET /orders
  def index
    unless current_user.admin || current_user.id == params[:user_id]
      render json: { status: 401, message: "You are not authorized to access this resource" }, status: 401
      return
    end

    @orders = Order.find_by(user_id: params[:user_id])

    render json: @orders
  end

  # GET /orders/1
  def show
    unless current_user.admin || @order.user_id == current_user.id
      render json: { status: 401, message: "You are not authorized to access this resource" }, status: 401
      return
    end
    render json: @order
  end

  # POST /orders
  def create
    # @order = Order.new(order_params)

    current_user.cart.create_order(params[:order][:address])
    render json: { response: "Order created" }, status: :created
    # if @order.save
    #   render json: @order, status: :created, location: @order
    # else
    #   render json: @order.errors, status: :unprocessable_entity
    # end
  end

  # PATCH/PUT /orders/1
  def update
    unless current_user.admin || @order.user_id == params[:user_id]
      render json: { status: 401, message: "You are not authorized to access this resource" }, status: 401
      return
    end
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy!
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
