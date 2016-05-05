class AddUserIdToUrlShares < ActiveRecord::Migration[5.0]
  def change
    add_reference :url_shares, :user, index: true, foreign_key: true
  end
end
