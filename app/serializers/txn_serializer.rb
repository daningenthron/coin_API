class TxnSerializer < ActiveModel::Serializer
  attributes :id, :txn_type, :value, :coin_id, :api_key_id, :created_at, :updated_at
end
