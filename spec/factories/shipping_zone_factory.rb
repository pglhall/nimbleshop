FactoryGirl.define do
  factory :country_shipping_zone do |f|
    country_code "US"
  end
end

FactoryGirl.define do
  factory :regional_shipping_zone do |f|
    country_shipping_zone
    state_code "AL"
    country_code "US"
  end
end

