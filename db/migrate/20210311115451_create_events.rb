class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.belongs_to :user
      t.bigint :speaker_id, index: true, foreign_key: true
      t.integer :kind, dafault: 0
      t.datetime :date, null: false
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.string :name, null: false
      t.string :location, null: false
      t.text :description
      t.integer :limit

      t.timestamps
    end
  end
end
