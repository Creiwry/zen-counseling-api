class InvoicesController < ApplicationController
  include InvoiceCreator
  before_action :set_invoice, only: %i[ show update destroy ]
  before_action :authenticate_user!
  before_action :check_if_admin, only: %i[create update destroy]

  # GET /invoices
  def index
    unless current_user.admin || current_user.id == params[:user_id]
      render json: { status: 401, message: "You are not authorized to access this resource" }, status: 401
      return
    end
    @invoices = Invoice.find_by(client_id: params[:user_id])

    render json: @invoices
  end

  # GET /invoices/1
  def show
    unless current_user.admin || current_user.id == @invoice.client_id
      render json: { status: 401, message: "You are not authorized to access this resource" }, status: 401
      return
    end
    render json: { invoice: @invoice, document: url_for(@invoice.document) }
  end

  # POST /invoices
  def create
    @invoice = Invoice.new(invoice_params)
    user = User.find(params[:user_id])
    @invoice.client = user
    @invoice.admin = current_user
    @invoice.create_appointments
    create_invoice_pdf(@invoice)

    if @invoice.save
      render json: @invoice, status: :created
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /invoices/1
  def update
    if @invoice.update(invoice_params)
      @invoice.update_appointments
      render json: @invoice
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # DELETE /invoices/1
  def destroy
    @invoice.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def check_if_admin
    return if current_user.admin

    render json: { status: 401, message: "You are not authorized to access this resource" }, status: 401
  end
  # Only allow a list of trusted parameters through.
  def invoice_params
    params.require(:invoice).permit(:appointment_number, :total, :status, :user_id, :admin_id, :stripe_customer_id, :document)
  end
end
