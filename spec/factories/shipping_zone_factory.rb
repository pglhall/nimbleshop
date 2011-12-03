FactoryGirl.define do
  factory :shipping_zone do |f|
    sequence(:name) { |t| "USA#{t}" }
  end
end
