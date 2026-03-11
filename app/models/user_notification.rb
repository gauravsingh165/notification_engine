class UserNotification < ApplicationRecord
  belongs_to :user
  belongs_to :notification

  enum status: { pending: 0, delivered: 1, read: 2 }
end