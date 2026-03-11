module Admin
  class NotificationsController < ApplicationController
    before_action :require_admin
    def create
      notification = Notification.new(notification_params)
      notification.created_by = @current_user.id

      if notification.save
        render json: notification, status: :created
      else
        render json: { errors: notification.errors.full_messages }, status: :unprocessable_entity
      end
    end


    def index
      notifications = Notification.all
      render json: notifications
    end


    def show
      notification = Notification.find(params[:id])
      render json: notification
    end

    def send_notification
        notification = Notification.find(params[:id])

        NotificationSenderService.new(notification).call

        render json: { message: "Notification delivery started" }
    end

    private

    def require_admin
      unless @current_user.admin?
        render json: { error: "Admin access required" }, status: :forbidden
      end
    end

    def notification_params
      params.permit(:title, :message, :status, :scheduled_at)
    end

  end
end