class SearchResourceSerializer < ActiveModel::Serializer
  include ActiveModel

  attributes :collections, :bundles

  def collections
    serializer = CollectionsSerializer
    ArraySerializer.new(object[:collections], each_serializer: serializer)
  end

  def bundles
    serializer = BundlesSerializer
    ArraySerializer.new(object[:bundles], each_serializer: serializer)
  end
end
