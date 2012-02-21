FactoryGirl.define do
  factory :shipping_method do
    sequence(:name) { |t| "name#{t}" }
    active true

    trait :country do
      association :shipping_zone, factory: :country_shipping_zone
      lower_price_limit  10
      upper_price_limit  20
      base_price    2.99
    end

    factory :country_shipping_method,   traits: [:country]
  end
end
