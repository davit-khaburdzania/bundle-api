class AddLinkCountToBundle < ActiveRecord::Migration[5.0]
  def change
    add_column :bundles, :links_count, :integer, default: 0
  end
end
