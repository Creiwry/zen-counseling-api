# frozen_string_literal: true

class Store::CheckoutController < ApplicationController
  # before_action :authenticate_user!

  def create
    order = Order.find(params[:order_id].to_i)

    line_items_stripe = order.stripe_line_items
    session = Stripe::Checkout::Session.create(
      {
        ui_mode: 'embedded',
        line_items: line_items_stripe,
        mode: 'payment',
        return_url: 'http://localhost:5173/return?session_id={CHECKOUT_SESSION_ID}'
      }
    )

    render json: { clientSecret: session.client_secret }
  end

  def session_status
    order = Order.find(params[:order_id].to_i)
    session = Stripe::Checkout::Session.retrieve(params[:session_id])

    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)

    order.update(status: 'paid') if @payment_intent.status == 'succeeded'

    render json: { status: session.status, customer_email: session.customer_details.email }
  rescue Stripe::StripeError => e
    Rails.logger.error("Stripe error during charge: #{e.message}")
    puts json: { message: e.message, error_type: "Stripe" }
  rescue StandardError => e
    Rails.logger.error("Failed to create order for user: #{current_user.id}")
    puts json: { message: e.message, error_type: "Standard" }
    refund_payment(@payment_intent.id)
  end

  def cancel; end

  private

  def refund_payment(payment_intent_id)
    refund = Stripe::Refund.create(
      {
        payment_intent: payment_intent_id
      }
    )
    if refund.status == 'succeeded'
      puts json: { message: 'Payment was refunded.', error_type: "Standard" }
      Rails.logger.info("Payment was refunded: #{refund.id}")
    else
      puts json: { message: 'Failed to refund payment.', error_type: "Standard" }
      Rails.logger.warn("Failed to refund payment for payment intent: #{payment_intent_id}")
    end
  rescue Stripe::StripeError => e
    Rails.logger.error("Stripe error during charge: #{e.message}")
    puts json: { message: e.message, error_type: "Stripe" }
  rescue StandardError => e
    # Rails.logger.error("Failed to create order for user: #{current_user.id}")
    puts json: { message: e.message, error_type: "Standard" }
    refund_payment(@payment_intent.id)
  end
end
