class Share < ApplicationRecord
  belongs_to :sharable, polymorphic: true, counter_cache: true
  belongs_to :permission
  belongs_to :user
end
