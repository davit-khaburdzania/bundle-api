class CreateCollections < ActiveRecord::Migration[5.0]
  def change
    create_table :collections do |t|
      t.string :name
      t.integer :creator_id

      t.timestamps
    end
  end
end
