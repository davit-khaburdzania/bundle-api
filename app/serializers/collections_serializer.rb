class CollectionsSerializer < ActiveModel::Serializer
  attributes :id, :name, :bundles_count, :favorites_count,
    :shares_count, :favorited, :created_at

  def favorited
    object.favorited_by?(scope)
  end

  def shares_count
    4
  end

  def id
    object.slug
  end
end
