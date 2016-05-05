class UrlShareSerializer < ActiveModel::Serializer
  attributes :id, :sharable_by_url_id, :sharable_by_url_type
end
