class NotificationSenderService

  def initialize(notification)
    @notification = notification
  end

  def call
    return if @notification.scheduled? && @notification.scheduled_at > Time.current
    users = User.user

    users.find_each do |user|
      user_notification = UserNotification.create!(
        user: user,
        notification: @notification,
        status: :pending
      )

      DeliverNotificationJob.perform_later(user_notification.id)
    end

    @notification.update(status: :sent)
  end

end