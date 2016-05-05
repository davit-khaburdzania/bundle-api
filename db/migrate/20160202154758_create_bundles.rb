class CreateBundles < ActiveRecord::Migration[5.0]
  def change
    create_table :bundles do |t|
      t.string :name
      t.text :description
      t.integer :creator_id
      t.integer :collection_id

      t.timestamps
    end
  end
end
