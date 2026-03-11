class AddUniqueIndexToUserNotifications < ActiveRecord::Migration[7.0]
  def change
    add_index :user_notifications, [:user_id, :notification_id], unique: true
  end
end