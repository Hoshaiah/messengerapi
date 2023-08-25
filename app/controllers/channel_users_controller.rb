class ChannelUsersController < ApplicationController
    before_action :set_channel_user, only: %i[ show update destroy ]
    before_action :authenticate_user, only: [:create, :index]
  
    # GET /channel_users
    def index
      @channel_users = ChannelUser.where(channel_id: params['channel_id'])
  
      render json: @channel_users
    end
  
    # GET /channel_users/1
    # def show
    #   render json: @channel_user
    # end
  
    # POST /channel_users
    def create
      # byebug
      @channel_user = ChannelUser.new(channel_user_params)
  
      if @channel_user.save
        render json: @channel_user, status: :created, location: @channel_user
      else
        render json: @channel_user.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /channel_users/1
    # def update
    #   if @channel_user.update(channel_user_params)
    #     render json: @channel_user
    #   else
    #     render json: @channel_user.errors, status: :unprocessable_entity
    #   end
    # end
  
    # DELETE /channel_users/1
    def destroy
      @channel_user.destroy
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_channel_user
        @channel_user = ChannelUser.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def channel_user_params
        params.require(:channel_user).permit(:channel_id, :user_id)
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
  
  
        channel = Channel.find_by(id: params['channel_id'])
        if channel.nil?
          render json: {
            status: 404,
            message: "Channel does not exist."
          } 
          return
        end


        # if !channel.users.ids.include? current_user.id
        # render json: {
        #   status: 404,
        #   message: "User is not part of this channel"
        # }
        # return
        # end
      end
  end
  