class Counselling::AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[show update destroy]
  before_action :authenticate_user!

  # GET /appointments
  def index
    appointments = current_user.admin ? Appointment.where(admin: current_user) : Appointment.where(client: current_user)

    if params[:date] != ''
      date = params[:date].to_date
      appointments = appointments.filter_based_on_date(date)
    end
    render_response(200, 'index rendered', :ok, appointments)
  end

  # GET /appointments/1
  def show
    if current_user == @appointment.admin || current_user == @appointment.client
      render_response(200, 'show appointment', :ok, @appointment)
    else
      render_response(401, 'You are not authorized to create this resource', :unauthorized, nil)
    end
  end

  # POST /appointments
  def create
    invoice = Invoice.find(params[:invoice_id])
    if check_admin(invoice.admin) || check_client(invoice.client)
      client = User.find(params[:user_id])
      @appointment = Appointment.new(
        appointment_params,
        admin: current_user,
        client:,
        invoice:
      )

      if @appointment.save
        render_response(201, 'Appointment created', :created, @appointment)
      else
        render_response(422, @appointment.errors, :unprocessable_entity, nil)
      end
    else
      render_response(401, 'You are not authorized to create this resource', :unauthorized, nil)
    end
  end

  # PATCH/PUT /appointments/1
  def update
    if check_admin(current_user) || check_client(current_user)
      if @appointment.update(appointment_params)
        render_response(200, 'resource updated successfully', :ok, @appointment)
      else
        render_response(422, @appointment.errors, :unprocessable_entity, @appointment)
      end
    else
      render_response(401, 'You are not authorized to change this resource', :unauthorized, nil)
    end
  end

  # DELETE /appointments/1
  def destroy
    if check_admin(current_user) || check_client(current_user)
      @appointment.destroy!
      render_response(200, 'resource deleted successfully', :ok, nil)
    else
      render_response(401, 'You are not authorized to change this resource', :unauthorized, nil)
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  def check_admin(user)
    appointment = Appointment.find(params[:id])
    user == appointment.admin
  end

  def check_client(user)
    appointment = Appointment.find(params[:id])
    user == appointment.client
  end

  # Only allow a list of trusted parameters through.
  def appointment_params
    params.require(:appointment).permit(:invoice_id, :user_id, :admin_id, :datetime, :appointment_type, :link, :status)
  end
end
