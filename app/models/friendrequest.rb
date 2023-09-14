class Friendrequest < ApplicationRecord
    belongs_to :user
    belongs_to :friend, class_name: 'User'
    validates :user_id, uniqueness: {scope: :friend_id}

    def get_user_data(user_id)
        user = User.find_by(id:user_id)
        return {id: user_id, email: user.email, name: user.name}
    end
end
