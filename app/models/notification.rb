class Notification < ApplicationRecord
  enum status: { draft: 0, scheduled: 1, sent: 2 }

  validates :title, presence: true
  validates :message, presence: true

  belongs_to :creator, class_name: "User", foreign_key: "created_by"

  validate :scheduled_time_in_future

  def scheduled_time_in_future
    return if scheduled_at.blank?

    if scheduled_at <= Time.current
      errors.add(:scheduled_at, "must be in the future")
    end
  end
end