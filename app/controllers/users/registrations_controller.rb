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

    def update
      self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

      prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

      resource_updated = update_resource(resource, account_update_params)

      yield resource if block_given?
      if resource_updated
        set_flash_message_for_update(resource, prev_unconfirmed_email)
        bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

        respond_with resource, resource_updated: resource_updated, location: after_update_path_for(resource)
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource, resource_updated: resource_updated
      end
    end

    private

    def respond_with(resource, opts = {})
      if request.method == 'POST' && resource.persisted?
        data = UserSerializer.new(resource).serializable_hash[:data][:attributes]
        render_response(200, 'Signed up successfully', :ok, data)
      elsif request.method == 'PATCH' && opts[:resource_updated]
        data = UserSerializer.new(resource).serializable_hash[:data][:attributes]
        render_response(200, 'Resource updated successfully', :ok, data)
      elsif request.method == 'PATCH' && !opts[:resource_updated]
        data = UserSerializer.new(resource).serializable_hash[:data][:attributes]
        render_response(422, 'Couldn\'t update user', :ok, data)
      elsif request.method == 'DELETE'
        render_response(200, 'Account deleted successfully.', :unprocessable_entity, nil)
      else
        errors = resource.errors.full_messages.to_sentence
        render_response(422, "User couldn't be created successfully. #{errors}", :unprocessable_entity, nil)
      end
    end
  end
end
