class ApplicationController < ActionController::API
  before_action :configure_devise_parameters, if: :devise_controller?

  rescue_from ActionDispatch::Http::Parameters::ParseError do
    render json: { status: 400, message: 'Bad Request: Error occurred while parsing request parameters' }
  end

  def configure_devise_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:first_name, :last_name, :admin, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:first_name, :last_name, :admin, :email, :password, :password_confirmation, :current_password)
    end
  end
end
