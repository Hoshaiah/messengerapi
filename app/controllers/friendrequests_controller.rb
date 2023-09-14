class FriendrequestsController < ApplicationController
  before_action :set_friendrequest, only: %i[ show update destroy ]

  # GET /friendrequests
  def index
    @friendrequests = Friendrequest.where(friend_id: friendrequest_params['friend_id'])

    render json: @friendrequests
  end

  # GET /friendrequests/1
  def show
    render json: @friendrequest
  end

  # POST /friendrequests
  def create
    #if friendship already exists, cancel creating friend request
    @friendship_exists = Friendship.where(friendrequest_params).any?
    if @friendship_exists
      render json: { message: 'This friendship already exists'}
      return
    end

    #if the other user sent a friend request, cancel the creation of friend request and just create a friendship
    @parallel_friendrequest = Friendrequest.where(user_id: friendrequest_params['friend_id'], friend_id: friendrequest_params['user_id'])
    if @parallel_friendrequest.any?
      @friendship = Friendship.new(friendrequest_params)
      @friendship_parallel= Friendship.new(user_id: friendrequest_params['friend_id'], friend_id: friendrequest_params['user_id'] )

    
      ActiveRecord::Base.transaction do
        if @friendship.save && @friendship_parallel.save && @parallel_friendrequest.first.destroy
          json = {
            data: [@friendship, @friendship_parallel],
            message: "You both sent a friend request so now you are friends. Cheers!"
          }
          render json: json, status: :created
        else 
          render json: {error: {message:"Adding friend was not successful" }}
          raise ActiveRecord::Rollback
        end
      end
      return
    end
    
    @friendrequest = Friendrequest.new(friendrequest_params)

    if @friendrequest.save
      render json: @friendrequest, status: :created, location: @friendrequest
    else
      render json: @friendrequest.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /friendrequests/1
  def update
    if @friendrequest.update(friendrequest_params)
      render json: @friendrequest
    else
      render json: @friendrequest.errors, status: :unprocessable_entity
    end
  end

  # DELETE /friendrequests/1
  def destroy
    @friendrequest.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friendrequest
      @friendrequest = Friendrequest.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def friendrequest_params
      params.require(:friendrequests).permit(:user_id, :friend_id)
    end
end
