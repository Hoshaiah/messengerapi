class FriendshipsController < ApplicationController
  before_action :set_friendship, only: %i[ show update destroy ]
  before_action :authenticate_user, only: %i[index]

  # GET /friendships
  def index
    @friendships = current_user.friendships

    friend_data = @friendships.map do |friend|
      friend.getFriendData(friend.friend_id)
    end
    render json: friend_data
  end

  # GET /friendships/1
  def show
    render json: @friendship
  end

  # POST /friendships
  def create
    @friendship = Friendship.new(friendship_params)
    @friendship_parallel= Friendship.new(user_id: friendship_params['friend_id'], friend_id: friendship_params['user_id'] )
    
    ActiveRecord::Base.transaction do
      # Attempt to save both items
      if @friendship.save && @friendship_parallel.save
        # If both saves are successful, commit the transaction
        render json: [@friendship, @friendship_parallel], status: :created 
      else
        # If any save fails, roll back the transaction
        render json: {error: {message:"Adding friend was not successful" }}
        raise ActiveRecord::Rollback
      end
    end
  end

  # PATCH/PUT /friendships/1
  def update
    if @friendship.update(friendship_params)
      render json: @friendship
    else
      render json: @friendship.errors, status: :unprocessable_entity
    end
  end

  # DELETE /friendships/1
  def destroy
    @friendship.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friendship
      @friendship = Friendship.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def friendship_params
      params.require(:friendship).permit(:user_id, :friend_id)
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
    end
end
