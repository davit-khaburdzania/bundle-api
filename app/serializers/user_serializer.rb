class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :image, :auth_token
end
