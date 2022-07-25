# frozen_string_literal: true

class AddViewsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :views, :integer, default: 0
  end
end
