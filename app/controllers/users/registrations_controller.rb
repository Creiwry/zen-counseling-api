# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix
  respond_to :json

  def destroy
    resource.destroy
    set_flash_message! :notice, :destroyed
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name), status: Devise.responder.redirect_status }
  end

  private

  def respond_with(resource, _opts = {})
    if request.method == "POST" && resource.persisted?
      render json: {
        status: {code: 200, message: "Signed up sucessfully."},
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }, status: :ok
    elsif request.method == "DELETE"
      render json: {
        status: { code: 200, message: "Account deleted successfully."}
      }, status: :ok
    else
      render json: {
        status: {code: 422, message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"}
      }, status: :unprocessable_entity
    end
  end
end
