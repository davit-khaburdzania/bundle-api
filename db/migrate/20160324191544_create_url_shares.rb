class CreateUrlShares < ActiveRecord::Migration[5.0]
  def change
    create_table :url_shares do |t|
      t.integer :sharable_by_url_id
      t.string :sharable_by_url_type

      t.timestamps
    end
  end
end
