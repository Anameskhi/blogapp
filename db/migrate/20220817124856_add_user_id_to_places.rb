class AddUserIdToPlaces < ActiveRecord::Migration[7.0]
  def change
    add_reference :places, :user, null: false, foreign_key: true
  end
end
