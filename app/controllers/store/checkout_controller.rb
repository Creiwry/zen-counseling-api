# frozen_string_literal: true

module Store
  class CheckoutController < ApplicationController
    before_action :authenticate_user!
    before_action :auth_user_access

    def create
      order = Order.find(params[:order_id].to_i)

      line_items_stripe = order.stripe_line_items
      session = Stripe::Checkout::Session.create(
        {
          ui_mode: 'embedded',
          line_items: line_items_stripe,
          mode: 'payment',
          return_url: "#{ENV.fetch('PRODUCTION_URL',
                                   'localhost:3000')}#{params[:return_url]}?session_id={CHECKOUT_SESSION_ID}"
        }
      )

      render json: { clientSecret: session.client_secret }
    end

    def session_status
      order = Order.find(params[:order_id].to_i)
      session = Stripe::Checkout::Session.retrieve(params[:session_id])

      @session = Stripe::Checkout::Session.retrieve(params[:session_id])
      @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)

      if @payment_intent.status == 'succeeded'
        order.update(status: 'paid', payment_intent_id: @payment_intent.id, refundable: true)
      end

      render json: { status: session.status, customer_email: session.customer_details.email }
    rescue Stripe::StripeError => e
      Rails.logger.error("Stripe error during charge: #{e.message}")
      puts json: { message: e.message, error_type: 'Stripe' }
    rescue StandardError => e
      Rails.logger.error("Failed to create order for user: #{current_user.id}")
      puts json: { message: e.message, error_type: 'Standard' }
      refund_payment(@payment_intent.id)
    end

    def refund
      order = Order.find(params[:order_id])
      refund = Stripe::Refund.create(
        {
          payment_intent: order.payment_intent_id
        }
      )
      if refund.status == 'succeeded'
        Rails.logger.info("Payment was refunded: #{refund.id}")
        order.update(status: 'refunded', refundable: false)
      else
        Rails.logger.warn("Failed to refund payment for payment intent: #{payment_intent_id}")
      end
    rescue Stripe::StripeError => e
      Rails.logger.error("Stripe error during charge: #{e.message}")
    rescue StandardError => e
      Rails.logger.error("Failed to update order for user: #{e.message}")
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
        Rails.logger.info("Payment was refunded: #{refund.id}")
      else
        Rails.logger.warn("Failed to refund payment for payment intent: #{payment_intent_id}")
      end
    rescue Stripe::StripeError => e
      Rails.logger.error("Stripe error during charge: #{e.message}")
    rescue StandardError => e
      Rails.logger.error("Failed to create order for user: #{e.message}")
    end

    def auth_user_access
      order = Order.find(params[:order_id])
      return if current_user == order.user

      render_response(401, 'You are not authorized to access this resource', :unauthorized, nil)
    end
  end
end
