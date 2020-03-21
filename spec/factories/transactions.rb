FactoryBot.define do
  factory :transaction do
    type { "deposit" }
    value { 5 }
    coin_id { nil }
    api_key_id { nil }
  end
end
