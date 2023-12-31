class ChannelsController < ApplicationController
    before_action :set_channel, only: %i[ show update destroy ]
    before_action :authenticate_user, only: [:index, :create]
  
    # GET /channels
    def index
      @channels = current_user.channels
  
      render json: {data: @channels}
    end
  
    # GET /channels/1
    def show
      render json: {
        data: {
            **JSON.parse(@channel.to_json),
            channel_members: @channel.users
        }
    }
    end
  
    # POST /channels
    def create
    
      @channel = Channel.new(channel_params)
      if @channel.save
        render json: @channel, status: :created, location: @channel
      else
        render json: @channel.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /channels/1
    def update
      if @channel.update(channel_params)
        render json: @channel
      else
        render json: @channel.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /channels/1
    def destroy
      @channel.destroy
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_channel
        @channel = Channel.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def channel_params
        params.require(:channel).permit(:name)
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
          }, status: :forbidden
          return
        end
  
  
        # if params['recipient_type'] == 'Channel'
        #   channel = Channel.find_by(id: params['recipient_id'])
        #   if channel.nil?
        #     render json: {
        #       status: 404,
        #       message: "Channel does not exist."
        #     } 
        #     return
        #   end
  
  
        #   if !channel.users.ids.include? current_user.id
        #   render json: {
        #     status: 404,
        #     message: "User is not part of this channel"
        #   }
        #   return
        #   end
        # end
      end
  end
  