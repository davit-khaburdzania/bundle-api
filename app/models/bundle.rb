class Bundle < ApplicationRecord
  include Slugable
  include Sharable
  include Invitable
  include Favoritable

  has_many :links, dependent: :destroy
  has_one :url_share, as: :sharable_by_url, dependent: :destroy
  has_many :shares, as: :sharable, dependent: :destroy
  has_many :invites, as: :invitable, dependent: :destroy
  has_many :favorites, as: :favoritable, dependent: :destroy
  belongs_to :creator, class_name: 'User'
  belongs_to :collection, required: false, counter_cache: true

  validates_presence_of :name
  default_scope { order('created_at DESC') }

  accepts_nested_attributes_for :links, allow_destroy: true
end
