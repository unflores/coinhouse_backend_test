class AddUniqIndexToEventsUsers < ActiveRecord::Migration[6.1]
  def change
    remove_index :events_users, :user_id
    remove_index :events_users, :event_id

    add_index :events_users, [:user_id, :event_id], unique: true
  end
end
