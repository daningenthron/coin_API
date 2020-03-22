FactoryBot.define do
  factory :coin do
    value { [1, 5, 10, 25].sample }
  end
end
