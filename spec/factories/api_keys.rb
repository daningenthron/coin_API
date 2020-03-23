FactoryBot.define do
  factory :api_key do
    email { Faker::Internet.email }
  end
end
