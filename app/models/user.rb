class User < ApplicationRecord
  has_many :channel_users, dependent: :destroy
  has_many :channels, through: :channel_users
  has_many :messages, as: :recipient
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :name, presence: true
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  require 'fuzzy_match'

  def self.fuzzy_search(query)
    results = []

    # Fuzzy search in id column
    id_matcher = FuzzyMatch.new(User.pluck(:id))
    results += where(id: id_matcher.find(query))

    # Fuzzy search in email column
    email_matcher = FuzzyMatch.new(User.pluck(:email))
    results += where(email: email_matcher.find(query))

    # Fuzzy search in name column
    name_matcher = FuzzyMatch.new(User.pluck(:name))
    results += where(name: name_matcher.find(query))

    results.uniq
  end

end
