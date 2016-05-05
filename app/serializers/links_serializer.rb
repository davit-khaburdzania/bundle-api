class LinksSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :title, :description, :url, :image
end
