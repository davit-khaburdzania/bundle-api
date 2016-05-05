class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.integer :creator_id
      t.references :bundle, foreign_key: true
      t.string :title
      t.text :description
      t.string :image

      t.timestamps
    end
  end
end
