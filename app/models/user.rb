class User < ApplicationRecord
  enum role: { user: 0, admin: 1 }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :user_notifications
  has_many :notifications, through: :user_notifications
  
  before_create :generate_auth_token

  private

  def generate_auth_token
    self.auth_token = SecureRandom.hex(20)
  end
end