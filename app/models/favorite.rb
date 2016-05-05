class Favorite < ApplicationRecord
  belongs_to :favoritable, polymorphic: true, counter_cache: true
  belongs_to :user

  default_scope { order('created_at DESC') }
end
