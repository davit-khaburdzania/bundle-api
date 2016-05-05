class Link < ApplicationRecord
  belongs_to :bundle, counter_cache: true
  belongs_to :creator, class_name: 'User'

  validates :title, presence: true, length: { minimum: 3 }
end
