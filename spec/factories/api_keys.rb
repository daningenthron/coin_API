FactoryBot.define do
  factory :api_key do
    key { SecureRandom.hex(4) }
    email { Faker::Internet.email }
    admin { false }
  end
end
