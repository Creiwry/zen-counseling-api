# frozen_string_literal: true

module Counselling
  class PrivateMessagesController < ApplicationController
    before_action :set_private_message, only: %i[show update destroy]
    before_action :authenticate_user!
    before_action :check_user_access, only: %i[show]
    before_action :check_user_sender, only: %i[update destroy]

    # GET /private_messages
    def index
      other_user = User.find(params[:user_id])
      sent_messages = PrivateMessage.where(sender: current_user).where(recipient: other_user)
      received_messages = PrivateMessage.where(recipient: current_user).where(sender: other_user)
      all_messages = sent_messages + received_messages

      all_messages = all_messages.sort_by(&:created_at) unless all_messages.empty?

      render_response(200, 'index rendered', :ok, all_messages)
    end

    def list_chats
      other_chat_users = current_user.existing_chats

      render_response(200, 'index other chat users', :ok, other_chat_users)
    end

    # GET /private_messages/1
    def show
      render json: @private_message
    end

    # POST /private_messages
    def create
      recipient = User.find(params[:user_id])
      @message = PrivateMessage.new(recipient:, sender: current_user, content: params[:private_message][:content])

      if @message.save
        render_response(201, 'Message created', :created, @message)
      else
        render_response(422, @message.errors, :unprocessable_entity, nil)
      end
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

    def check_user_access
      return if @private_message.sender == current_user || @private_message.recipient == current_user

      render_response(401, 'You are not authorized to access this resource', :unauthorized, nil)
    end

    def check_user_sender
      return if @private_message.sender == current_user

      render_response(401, 'You are not authorized to edit this resource', :unauthorized, nil)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_private_message
      @private_message = PrivateMessage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def private_message_params
      params.require(:private_message).permit(:content)
    end
  end
end
