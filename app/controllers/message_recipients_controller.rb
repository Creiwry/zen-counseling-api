class MessageRecipientsController < ApplicationController
  before_action :set_message_recipient, only: %i[ show update destroy ]

  # GET /message_recipients
  def index
    @message_recipients = MessageRecipient.all

    render json: @message_recipients
  end

  # GET /message_recipients/1
  def show
    render json: @message_recipient
  end

  # POST /message_recipients
  def create
    @message_recipient = MessageRecipient.new(message_recipient_params)

    if @message_recipient.save
      render json: @message_recipient, status: :created, location: @message_recipient
    else
      render json: @message_recipient.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /message_recipients/1
  def update
    if @message_recipient.update(message_recipient_params)
      render json: @message_recipient
    else
      render json: @message_recipient.errors, status: :unprocessable_entity
    end
  end

  # DELETE /message_recipients/1
  def destroy
    @message_recipient.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message_recipient
      @message_recipient = MessageRecipient.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_recipient_params
      params.require(:message_recipient).permit(:private_message_id, :users_id)
    end
end
