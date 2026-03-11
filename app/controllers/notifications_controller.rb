class NotificationsController < ApplicationController

  def index
    user = User.find(params[:user_id])

    notifications = user.user_notifications.includes(:notification)

    if params[:status] == "unread"
    notifications = notifications.where.not(status: :read)
    end
    result = notifications.map do |un|
      {
        id: un.notification.id,
        title: un.notification.title,
        message: un.notification.message,
        status: un.status,
        delivered_at: un.delivered_at,
        read_at: un.read_at
      }
    end

    render json: result
  end


  def read
    user = User.find(params[:user_id])

    user_notification = UserNotification.find_by!(
      user: user,
      notification_id: params[:id]
    )

    user_notification.update!(
      status: :read,
      read_at: Time.current
    )

    render json: { message: "Notification marked as read" }
  end

end