class Message < ApplicationRecord
    belongs_to :recipient, polymorphic: true
end
