# frozen_string_literal: true

class Counselling::CheckoutController < ApplicationController
  # before_action :authenticate_user!

  def create
    session = Stripe::Checkout::Session.create({
      ui_mode: 'embedded',
      line_items: [{
        price_data: {
          currency: 'eur',
          unit_amount: (5 * 100).to_i,
          product_data: {
            name: 'test'
          }
        },
        quantity: 1
      }],
      mode: 'payment',
      return_url: 'http://localhost:5173/return?session_id={CHECKOUT_SESSION_ID}'
    })

    render json: { clientSecret: session.client_secret }
  end

  def session_status
    session = Stripe::Checkout::Session.retrieve(params[:session_id])

    render json: { status: session.status, customer_email: session.customer_details.email }
  end

  def cancel; end

  private

  def create_order(stripe_customer_id)
    payment_intent_id = @payment_intent.id
    order = Order.new(
      user_id: current_user.id,
      stripe_customer_id:,
      total_price: current_user.cart.get_total
    )

    begin
      ActiveRecord::Base.transaction do
        order.save!
        order.create_order_items(session[:order_item_ids])
        current_user.cart.empty_cart
      end

      if @payment_intent.status == 'succeeded'
        flash[:success] = 'Order successfully created!'
      else
        order.destroy
        flash[:error] = 'Stripe charge failed.'
      end

      order
    rescue Stripe::StripeError => e
      flash[:error] = "Stripe error: #{e.message}"
      Rails.logger.error("Stripe error during charge: #{e.message}")
    rescue StandardError => e
      flash[:error] = "Failed to create order or order items: #{e.message}"
      Rails.logger.error("Failed to create order for user: #{current_user.id}")
      refund_payment(payment_intent_id)
    end
  end

  def refund_payment(payment_intent_id)
    refund = Stripe::Refund.create(
      {
        payment_intent: payment_intent_id
      }
    )
    if refund.status == 'succeeded'
      flash[:info] = 'Payment was refunded.'
      Rails.logger.info("Payment was refunded: #{refund.id}")
    else
      flash[:error] = 'Failed to refund payment.'
      Rails.logger.warn("Failed to refund payment for payment intent: #{payment_intent_id}")
    end
  rescue Stripe::StripeError => e
    flash[:error] = "Stripe error: #{e.message}"
    Rails.logger.error("Stripe error while refunding: #{e.message}")
  rescue StandardError => e
    flash[:error] = "General error: #{e.message}"
    Rails.logger.error("General error while refunding: #{e.message}")
  end
end
