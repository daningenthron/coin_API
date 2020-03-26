class AdminSerializer < ActiveModel::Serializer
  attributes :name, :email, :created_at, :updated_at
end
