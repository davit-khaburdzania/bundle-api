class FavoritesSerializer < ActiveModel::Serializer
  include ActiveModel::Serialization

  attributes :id, :favoritable, :favoritable_type, :created_at

  has_one :favoritable

  def favoritable
    if object.favoritable_type == 'Bundle'
      BundlesSerializer.new(object.favoritable, root: false, scope: scope)
    else
      CollectionsSerializer.new(object.favoritable, root: false, scope: scope)
    end
  end
end
