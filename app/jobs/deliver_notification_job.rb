require 'net/http'
require 'uri'
require 'json'

class DeliverNotificationJob < ApplicationJob
  queue_as :default

  retry_on StandardError, attempts: 3

  def perform(user_notification_id)

    user_notification = UserNotification.find(user_notification_id)
    notification = user_notification.notification
    user = user_notification.user

    uri = URI.parse("https://dummyjson.com/http/200")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, { 'Content-Type': 'application/json' })

    request.body = {
      user_id: user.id,
      message: notification.message
    }.to_json

    response = http.request(request)

    if response.code.to_i == 200
      user_notification.update!(
        status: :delivered,
        delivered_at: Time.current
      )
    else
      raise "Delivery failed"
    end

  end
end