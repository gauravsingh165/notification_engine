class NotificationSenderJob < ApplicationJob
  queue_as :default

  def perform(notification_id)
    notification = Notification.find(notification_id)

    NotificationSenderService.new(notification).call
  end
end