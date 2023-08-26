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

    if @friendship.save
      render json: @friendship, status: :created, location: @friendship
    else
      render json: @friendship.errors, status: :unprocessable_entity
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
