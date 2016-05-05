class SearchResource
  def initialize(user:, query:)
    @query = query
    @user = user
  end

  def search
    { collections: find_collections, bundles: find_bundles }
  end

private

  def find_collections
    @user.collections.where('name iLIKE ?', "%#{@query}%")
  end

  def find_bundles
    @user.bundles.where('name iLIKE ?', "%#{@query}%")
  end
end
