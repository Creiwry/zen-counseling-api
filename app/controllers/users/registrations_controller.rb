# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    include RackSessionFix
    respond_to :json

    def destroy
      resource.destroy
      set_flash_message! :notice, :destroyed
      yield resource if block_given?
      respond_with_navigational(resource) do
        redirect_to after_sign_out_path_for(resource_name), status: Devise.responder.redirect_status
      end
    end

    private

    def respond_with(resource, _opts = {})
      if request.method == 'POST' && resource.persisted?
        data = UserSerializer.new(resource).serializable_hash[:data][:attributes]
        render_response(200, 'Signed up successfully', :ok, data)
      elsif request.method == 'DELETE'
        render_response(200, 'Account deleted successfully.', :ok, nil)
      else
        errors = resource.errors.full_messages.to_sentence
        render_response(422, "User couldn't be created successfully. #{errors}", :unprocessable_entity, nil)
      end
    end
  end
end
