class AddPermissionToShares < ActiveRecord::Migration[5.0]
  def change
    add_column :shares, :permission_id, :integer, index: true, foreign_key: true
  end
end
