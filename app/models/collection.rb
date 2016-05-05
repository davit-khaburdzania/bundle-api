class Collection < ApplicationRecord
  include Slugable
  include Sharable
  include Invitable
  include Favoritable

  has_many :bundles, dependent: :destroy
  has_many :shares, as: :sharable, dependent: :destroy
  has_one :url_share, as: :sharable_by_url, dependent: :destroy
  has_many :invites, as: :invitable, dependent: :destroy
  has_many :favorites, as: :favoritable, dependent: :destroy
  belongs_to :creator, class_name: 'User'

  validates_presence_of :name
end
