# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :configure_devise_parameters, if: :devise_controller?
  rescue_from ActiveRecord::StatementInvalid, with: :handle_sql_injection

  rescue_from ActionDispatch::Http::Parameters::ParseError do
    render_response(400, 'Bad Request: Error occurred while parsing request parameters', :bad_request, nil)
  end

  rescue_from ActiveRecord::RecordNotFound do
    render_response(404, 'This record was not found', :not_found, nil)
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

  private

  def handle_sql_injection(exception)
    logger.error("SQL Injection attempt: #{exception.message}")

    render_response(400, 'Invalid request', :bad_request, nil)
  end
end
