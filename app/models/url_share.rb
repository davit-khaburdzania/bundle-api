class UrlShare < ApplicationRecord
  belongs_to :sharable_by_url, polymorphic: true
  belongs_to :permission
  belongs_to :user
end
