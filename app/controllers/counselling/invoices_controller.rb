class Counselling::InvoicesController < ApplicationController
  include InvoiceCreator
  before_action :set_invoice, only: %i[show update destroy]
  before_action :authenticate_user!
  before_action :check_if_admin, only: %i[create update destroy]

  # GET /invoices
  def index
    unless current_user.admin || current_user.id == params[:user_id].to_i
      render_response(401, 'You are not authorized to access this resource', :unauthorized, nil)
      return
    end

    @invoices = Invoice.where(client_id: params[:user_id].to_i)

    render_response(200, 'index rendered', :ok, @invoices)
  end

  # GET /invoices/1
  def show
    unless current_user.admin || current_user.id == @invoice.client_id
      render_response(401, 'You are not authorized to access this resource', :unauthorized, nil)
      return
    end
    render_response(200, 'show invoice', :ok, { invoice: @invoice, document: url_for(@invoice.document) })
  end

  # POST /invoices
  def create
    @invoice = Invoice.new(invoice_params)
    user = User.find(params[:user_id])
    @invoice.status = 'unpaid'
    @invoice.client = user
    @invoice.admin = current_user
    @invoice.create_appointments
    create_invoice_pdf(@invoice)

    if @invoice.save
      render_response(201, 'item created', :created, @invoice)
    else
      render_response(422, @invoice.errors, :unprocessable_entity, nil)
    end
  end

  # PATCH/PUT /invoices/1
  def update
    if @invoice.update(invoice_params)
      @invoice.update_appointments
      render_response(200, 'resource updated successfully', :ok, @invoice)
    else
      render_response(422, @invoice.errors, :unprocessable_entity, @invoice)
    end
  end

  # DELETE /invoices/1
  def destroy
    @invoice.destroy!
    render_response(200, 'resource deleted successfully', :ok, nil)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def check_if_admin
    return if current_user.admin

    render_response(401, 'You are not authorized to access this resource', :unauthorized, nil)
  end

  # Only allow a list of trusted parameters through.
  def invoice_params
    params.require(:invoice).permit(:appointment_number, :total, :status, :user_id, :admin_id, :stripe_customer_id, :document)
  end
end
