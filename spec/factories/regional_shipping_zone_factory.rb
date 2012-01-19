FactoryGirl.define do
  factory :regional_shipping_zone do |f|
    country_shipping_zone
    carmen_code "AL"
    name "ALABAMA"
  end
end
