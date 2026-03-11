class AddAuthTokenToUsers < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :auth_token, :string, null: false, default: ""
    add_index :users, :auth_token, unique: true
    change_column_default :users, :auth_token, nil
  end

  def down
    remove_index :users, :auth_token
    remove_column :users, :auth_token
  end
end
