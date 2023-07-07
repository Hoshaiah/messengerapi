class ChannelUsersController < ApplicationController
    before_action :set_channel_user, only: %i[ show update destroy ]
  
    # GET /channel_users
    def index
      @channel_users = ChannelUser.all
  
      render json: @channel_users
    end
  
    # GET /channel_users/1
    def show
      render json: @channel_user
    end
  
    # POST /channel_users
    def create
      # byebug
      @channel_user = ChannelUser.new(channel_user_params)
      byebug
  
      if @channel_user.save
        render json: @channel_user, status: :created, location: @channel_user
      else
        render json: @channel_user.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /channel_users/1
    def update
      if @channel_user.update(channel_user_params)
        render json: @channel_user
      else
        render json: @channel_user.errors, status: :unprocessable_entity
      end
    end
  
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
  end
  