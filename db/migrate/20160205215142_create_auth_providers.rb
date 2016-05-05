class CreateAuthProviders < ActiveRecord::Migration[5.0]
  def change
    create_table :auth_providers do |t|
      t.references :user, foreign_key: true
      t.integer :uid, limit: 8
      t.string :provider

      t.timestamps
    end
  end
end
