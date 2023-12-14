class PrivateMessagesController < ApplicationController
  before_action :set_private_message, only: %i[ show update destroy ]

  # GET /private_messages
  def index
    @private_messages = PrivateMessage.all

    render json: @private_messages
  end

  # GET /private_messages/1
  def show
    render json: @private_message
  end

  # POST /private_messages
  def create
    @private_message = PrivateMessage.new(private_message_params)

    if @private_message.save
      render json: @private_message, status: :created, location: @private_message
    else
      render json: @private_message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /private_messages/1
  def update
    if @private_message.update(private_message_params)
      render json: @private_message
    else
      render json: @private_message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /private_messages/1
  def destroy
    @private_message.destroy!
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
