class AddPermissionIdToUrlShare < ActiveRecord::Migration[5.0]
  def change
    add_column :url_shares, :permission_id, :integer, index: true, foreign_key: true
  end
end
