class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show update destroy ]
  before_action :authenticate_user, only: [:index, :create]

  # GET /messages
  def index
    # @messages = Message.all
    if params['recipient_type'] == 'User'
      @messages = Message.where(
        recipient_id: current_user.id,
        recipient_type: params['recipient_type'],
        sender_id: params['sender_id']
      )
    elsif params['recipient_type'] == 'Channel'
      @messages = Message.where(
        recipient_id: params['recipient_id'],
        recipient_type: params['recipient_type']
      )
    end
    render json: {data: @messages}
  end

  # GET /messages/1
  # def show
  #   render json: @messages
  # end

  # POST /messages
  def create
    @message = Message.new(message_params)
    @message.sender_id = current_user.id

    if @message.save
      render json: {
        data: @message, 
        message: 'Message was sent',
        status: 200
      }, status: :created, location: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /messages/1
  # def update
  #   if @message.update(message_params)
  #     render json: @message
  #   else
  #     render json: @message.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /messages/1
  # def destroy
  #   @message.destroy
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:body, :recipient_id, :recipient_type, :sender_id)
    end

    def authenticate_user
      if request.headers['Authorization'].present?
        jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first
        current_user = User.find(jwt_payload['sub'])
      end
      
      if !current_user || jwt_payload['jti'] != current_user.jti
        render json: {
          status: 404,
          message: "You do not have permission to do this action."
        }
        return
      end


      if params['recipient_type'] == 'Channel'
        channel = Channel.find_by(id: params['recipient_id'])
        if channel.nil?
          render json: {
            status: 404,
            message: "Channel does not exist."
          } 
          return
        end


        if !channel.users.ids.include? current_user.id
        render json: {
          status: 404,
          message: "User is not part of this channel"
        }
        return
        end
      end
    end
end
