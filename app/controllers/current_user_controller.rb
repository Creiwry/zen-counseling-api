class CurrentUserController < ApplicationController
  before_action :authenticate_user!

  def index
    data = UserSerializer.new(resource).serializable_hash[:data][:attributes]
    render_response(200, 'Current user', :ok, data)
  end
end
