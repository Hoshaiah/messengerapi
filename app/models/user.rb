class User < ApplicationRecord
  has_many :channel_users, dependent: :destroy
  has_many :channels, through: :channel_users
  has_many :messages, as: :recipient
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self
end
