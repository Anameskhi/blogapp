class AddSubscribesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :subscribed, :boolean, default: false
  end
end
