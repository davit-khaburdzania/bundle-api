class AddSharesCountToCollections < ActiveRecord::Migration[5.0]
  def change
    add_column :collections, :shares_count, :integer, default: 0
  end
end
