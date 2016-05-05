class Permission < ApplicationRecord
  has_many :invites
  has_many :shares
  has_many :url_shares
end
