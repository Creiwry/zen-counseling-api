class Counselling::AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[ show update destroy ]
  before_action :authenticate_user!

  # GET /appointments
  def index
    @appointments = Appointment.all

    render json: @appointments
  end

  # GET /appointments/1
  def show
    render json: @appointment
  end

  # POST /appointments
  def create
    @appointment = Appointment.new(appointment_params)
    user = User.find(params[:user_id])
    invoice = Invoice.find(params[:invoice_id])

    @appointment.admin = current_user
    @appointment.client = user
    @appointment.invoice = invoice

    if @appointment.save
      render json: @appointment, status: :created
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /appointments/1
  def update
    if @appointment.update(appointment_params)
      render json: @appointment
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /appointments/1
  def destroy
    @appointment.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  def check_current_user_admin
    appointment = Appointment.find(params[:id])
    return if current_user == appointment.admin

    render json: {
      status: {
        code: 401, errors: 'You are not authorized to change this appointment'
      }
    }, status: :unauthorized
  end

  def check_current_user_client
    appointment = Appointment.find(params[:id])
    return if current_user == appointment.client

    render json: {
      status: {
        code: 401, errors: 'You are not authorized to change this appointment'
      }
    }, status: :unauthorized
  end
  # Only allow a list of trusted parameters through.
  def appointment_params
    params.require(:appointment).permit(:invoice_id, :user_id, :admin_id, :datetime, :appointment_type, :link, :status)
  end
end
