class ApplicationController < ActionController::API

  def configure_devise_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:username, :admin, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:username, :admin, :email, :password, :password_confirmation, :current_password)
    end
  end
end
