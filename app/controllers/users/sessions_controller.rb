# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    include RackSessionFix
    respond_to :json

    private

    def respond_with(resource, _opts = {})
      data = UserSerializer.new(resource).serializable_hash[:data][:attributes]
      render_response(200, 'Logged in successfully', :ok, data)
    end

    def respond_to_on_destroy
      if current_user
        render_response(200, 'Logged out successfully', :ok, nil)
      else
        render_response(401, "Couldn't find an active session.", :unauthorized, nil)
      end
    end
  end
end
