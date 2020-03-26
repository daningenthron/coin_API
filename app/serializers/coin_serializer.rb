class CoinSerializer < ActiveModel::Serializer
  attributes :id, :value, :name, :created_at, :updated_at
end
