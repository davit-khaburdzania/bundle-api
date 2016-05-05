class AddPermissionToInvites < ActiveRecord::Migration[5.0]
  def change
    add_column :invites, :permission_id, :integer, index: true, foreign_key: true
  end
end
