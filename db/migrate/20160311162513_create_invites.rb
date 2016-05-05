class CreateInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :invites do |t|
      t.integer :inviter_id
      t.integer :invited_id
      t.integer :invitable_id
      t.string :invitable_type
      t.string :email
      t.text :token, unique: true

      t.timestamps
    end
  end
end
