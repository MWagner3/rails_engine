FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description {Faker::Lorem.sentence}
    unit_price { Faker::Number.within(range: 1..1000) }
    merchant_id {Faker::Number.within(range: 1..100)}
  end
end
