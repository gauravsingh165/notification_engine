class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :message
      t.integer :status
      t.datetime :scheduled_at
      t.integer :created_by

      t.timestamps
    end
  end
end
