class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :user_id, uniqueness: {scope: :friend_id}

  def getFriendData (friend_id)
    friend = User.find_by(id:friend_id)
    return {id: friend_id, name: friend.name, email: friend.email}
  end
end
