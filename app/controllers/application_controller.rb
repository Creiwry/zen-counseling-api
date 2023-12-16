# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :configure_devise_parameters, if: :devise_controller?

  rescue_from ActionDispatch::Http::Parameters::ParseError do
    render json: { status: 400, message: 'Bad Request: Error occurred while parsing request parameters' }, status: :bad_request
  end

  rescue_from ActiveRecord::RecordNotFound do
    render json: { status: :not_found, message: 'This record was not found' }, status: :not_found
  end

  def render_response(code, message, status, data)
    render json: {
      status: {
        code:, message:
      }, data:
    }, status:
  end

  def configure_devise_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
    end
  end
end
