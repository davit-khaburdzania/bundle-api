class BundleSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :favorites_count,
    :favorited, :links_count, :created_at, :full_response,
    :collection_id

  has_many :links
  has_one :creator

  def favorited
    object.favorited_by?(scope)
  end

  def id
    object.slug
  end

  def collection_id
    object.collection.try(:slug)
  end

  def full_response
    true
  end
end
