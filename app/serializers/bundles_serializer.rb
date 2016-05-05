class BundlesSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :favorites_count,
    :links_count, :favorited, :created_at

  def favorited
    object.favorited_by?(scope)
  end

  def id
    object.slug
  end
end
