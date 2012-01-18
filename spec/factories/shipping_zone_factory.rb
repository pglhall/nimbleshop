FactoryGirl.define do
  factory :shipping_zone do |f|
    sequence(:name) { |t| "USA#{t}" }
    sequence(:country_code) { |t| "US" }
  end
end
