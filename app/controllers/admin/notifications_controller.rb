module Admin
  class NotificationsController < ApplicationController

    def create
      notification = Notification.new(notification_params)
      notification.created_by = params[:admin_id]

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


    private

    def notification_params
      params.permit(:title, :message, :status, :scheduled_at)
    end

  end
end