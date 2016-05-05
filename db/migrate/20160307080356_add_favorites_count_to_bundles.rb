class AddFavoritesCountToBundles < ActiveRecord::Migration[5.0]
  def change
    add_column :bundles, :favorites_count, :integer, default: 0
  end
end
