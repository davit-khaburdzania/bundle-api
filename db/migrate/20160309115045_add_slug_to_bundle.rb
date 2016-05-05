class AddSlugToBundle < ActiveRecord::Migration[5.0]
  def change
    add_column :bundles, :slug, :string
    add_index :bundles, :slug, unique: true
  end
end
