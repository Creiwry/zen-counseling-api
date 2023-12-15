# frozen_string_literal: true

class Counselling::CheckoutController < ApplicationController
  before_action :authenticate_user!

  def create
    invoice = Invoice.find(params[:invoice_id].to_i)
    session = Stripe::Checkout::Session.create(
      {
        ui_mode: 'embedded',
        line_items: [{
          price_data: {
            currency: ENV.fetch('DEFAULT_CURRENCY', 'usd'),
            unit_amount: (invoice.total * 100).to_i,
            product_data: {
              name: "#{invoice.appointment_number} appointments"
            }
          },
          quantity: 1
        }],
        mode: 'payment',
        return_url: "http://localhost:5173#{params[:return_url]}?session_id={CHECKOUT_SESSION_ID}"
      }
    )

    render json: { clientSecret: session.client_secret }
  end

  def session_status
    invoice = Invoice.find(params[:invoice_id].to_i)
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)

    invoice.update(status: 'paid') if @payment_intent.status == 'succeeded'
    render json: { status: session.status, customer_email: session.customer_details.email }
  rescue Stripe::StripeError => e
    Rails.logger.error("Stripe error during charge: #{e.message}")
    render json: { message: e.message, error_type: "Stripe" }
  rescue StandardError => e
    Rails.logger.error("Failed to create order for user: #{current_user.id}")
    render json: { message: e.message, error_type: "Standard" }
    refund_payment(payment_intent_id)
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
    Rails.logger.error("Stripe error while refunding: #{e.message}")
  rescue StandardError => e
    Rails.logger.error("General error while refunding: #{e.message}")
  end
end
