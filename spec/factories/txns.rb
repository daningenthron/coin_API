FactoryBot.define do
  factory :txn do
    txn_type { "deposit" }
    value { 10 }
    coin_id { 1 }
    api_key_id { 1 }
  end
end
