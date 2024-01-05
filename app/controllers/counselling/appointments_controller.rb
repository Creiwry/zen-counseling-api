# frozen_string_literal: true

module Counselling
  class AppointmentsController < ApplicationController
    before_action :set_appointment, only: %i[show update destroy]
    before_action :authenticate_user!
    before_action :authorize_if_client_or_admin, only: %i[index index_by_date]

    def index_pending_confirmation
      unless current_user.admin
        render_response(401, 'You are not authorized to access this resource', :unauthorized, nil)
        return
      end
      appointments_to_send = Appointment.filter_pending_confirmation(current_user)

      render_response(200, 'index rendered', :ok, appointments_to_send)
    end

    def index
      appointments = current_user.admin ? Appointment.where(admin: current_user) : Appointment.where(client: current_user)

      appointments_to_send = []
      user_type = current_user.admin ? 'admin' : 'client'
      appointments.each do |appointment|
        appointments_to_send << appointment.attach_information_of_other_user(user_type)
      end
      render_response(200, 'index rendered', :ok, appointments_to_send)
    end

    def available_appointment
      appointment = current_user.available_appointment
      if appointment
        render_response(200, 'resource found', :ok, appointment)
      else
        render_response(200, 'resource not found', :ok, false)
      end
    end

    def confirmed_appointments
      appointments = current_user.admin ? Appointment.where(admin: current_user) : Appointment.where(client: current_user)
      appointments = appointments.where(status: 'confirmed')

      render_response(200, 'resources found', :ok, appointments)
    end

    def index_by_date
      appointments = current_user.admin ? Appointment.where(admin: current_user) : Appointment.where(client: current_user)

      date = params[:appointment_date].to_date
      appointments = appointments.filter_based_on_date(date).where(status: 'confirmed')
      appointments_to_send = []
      user_type = current_user.admin ? 'admin' : 'client'
      appointments.each do |appointment|
        appointments_to_send << appointment.attach_information_of_other_user(user_type)
      end

      render_response(200, 'index rendered', :ok, appointments_to_send)
    end

    # GET /appointments/1
    def show
      if current_user.admin || current_user == @appointment.client
        @appointment = @appointment.attach_information_of_other_user(current_user.admin ? 'admin' : 'client')
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

    def authorize_if_client_or_admin
      return if current_user.id == params[:user_id].to_i || current_user.admin

      render_response(401, 'You are not authorized to access this resource', :unauthorized, nil)
    end

    # Only allow a list of trusted parameters through.
    def appointment_params
      params.require(:appointment).permit(:invoice_id, :user_id, :admin_id, :datetime, :appointment_type, :link,
                                          :status)
    end
  end
end
