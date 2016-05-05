class LinkSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :title, :description, :url, :image

  has_one :creator
end
