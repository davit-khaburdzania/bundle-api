class CreateShares < ActiveRecord::Migration[5.0]
  def change
    create_table :shares do |t|
      t.integer :sharable_id
      t.string :sharable_type
      t.integer :user_id

      t.timestamps
    end
  end
end
