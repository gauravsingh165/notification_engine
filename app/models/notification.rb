class Notification < ApplicationRecord
  enum status: { draft: 0, scheduled: 1, sent: 2 }

  validates :title, presence: true
  validates :message, presence: true
  validates :scheduled_at, presence: true, if: :scheduled?

  belongs_to :creator, class_name: "User", foreign_key: "created_by"

  has_many :user_notifications
  has_many :users, through: :user_notifications

  validate :scheduled_time_in_future, if: :scheduled?

  def scheduled_time_in_future
    if scheduled_at <= Time.current
      errors.add(:scheduled_at, "must be in the future")
    end
  end
end