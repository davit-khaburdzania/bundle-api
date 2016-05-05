class AddFavoriteCountToCollections < ActiveRecord::Migration[5.0]
  def change
    add_column :collections, :favorites_count, :integer, default: 0
  end
end
