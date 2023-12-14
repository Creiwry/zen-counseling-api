class Counselling::PrivateMessagesController < ApplicationController
  before_action :set_private_message, only: %i[show update destroy]
  before_action :authenticate_user!

  # GET /private_messages
  def index
    @private_messages = PrivateMessage.all
    other_user = User.find(params[:user_id])
    sent_messages = PrivateMessage.find_conversation_messages(current_user, other_user)
    received_messages = PrivateMessage.find_conversation_messages(other_user, current_user)

    render_response(200, 'index rendered', :ok, { sent_messages:, received_messages: })
  end

  # GET /private_messages/1
  def show
    render json: @private_message
  end

  # POST /private_messages
  def create
    # @private_message = PrivateMessage.new(private_message_params)
    recipient = User.find(params[:user_id])
    message = current_user.send_message(recipient, params[:private_message][:content])

    render_response(201, 'Appointment created', :created, message)
  end

  # PATCH/PUT /private_messages/1
  def update
    if @private_message.update(private_message_params)
      render_response(200, 'resource updated successfully', :ok, @private_message)
    else
      render_response(422, @private_message.errors, :unprocessable_entity, @private_message)
    end
  end

  # DELETE /private_messages/1
  def destroy
    @private_message.destroy!
    render_response(200, 'resource deleted successfully', :ok, nil)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_private_message
    @private_message = PrivateMessage.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def private_message_params
    params.require(:private_message).permit(:content)
  end
end
