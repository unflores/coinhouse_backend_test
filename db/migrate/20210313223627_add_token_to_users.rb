class AddTokenToUsers < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.string :token
    end
  end
end
