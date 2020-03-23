FactoryBot.define do
  factory :txn do
    type { "deposit" }
    value { 5 }
    coin_id { nil }
    api_key_id { nil }
  end
end
