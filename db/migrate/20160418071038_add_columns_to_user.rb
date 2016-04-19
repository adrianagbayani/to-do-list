class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :device_token, :string
    add_column :users, :auth_token, :string
  end
end
