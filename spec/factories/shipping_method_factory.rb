FactoryGirl.define do
  factory :shipping_method do
    sequence(:name) { |t| "name#{t}" }
    lower_price_limit 10
    upper_price_limit 10
    shipping_price    10
    shipping_zone
  end
end
