class AddSharesCountToBundles < ActiveRecord::Migration[5.0]
  def change
    add_column :bundles, :shares_count, :integer, default: 0
  end
end
