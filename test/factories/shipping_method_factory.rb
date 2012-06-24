FactoryGirl.define do
  factory :shipping_method do
    sequence(:name) { |t| "name#{t}" }
    active true

    trait :country do
      association :shipping_zone, factory: :country_shipping_zone
      minimum_order_amount  0
      maximum_order_amount  99999
      base_price    2.99
    end

    factory :country_shipping_method,   traits: [:country]
  end
end
