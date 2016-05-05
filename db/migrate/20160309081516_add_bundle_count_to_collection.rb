class AddBundleCountToCollection < ActiveRecord::Migration[5.0]
  def change
    add_column :collections, :bundles_count, :integer, default: 0
  end
end
