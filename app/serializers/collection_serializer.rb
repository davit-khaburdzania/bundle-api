class CollectionSerializer < ActiveModel::Serializer
  class BundleSerializer < ActiveModel::Serializer
    attributes :id, :name, :description, :created_at, :links_count,
      :favorited

    def favorited
      object.favorited_by?(scope)
    end

    def id
      object.slug
    end
  end

  attributes :id, :name, :favorites_count, :bundles_count,
    :created_at, :full_response, :shares_count, :favorited

  has_many :bundles, serializer: BundleSerializer

  def id
    object.slug
  end

  def full_response
    true
  end

  def favorited
    object.favorited_by?(scope)
  end

  def shares_count
    4
  end
end
