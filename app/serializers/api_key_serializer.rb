class ApiKeySerializer < ActiveModel::Serializer
  attributes :id, :key_str, :email, :admin, :created_at, :updated_at
  has_many :txns
end
