class User < ApplicationRecord
  enum role: { user: 0, admin: 1 }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
