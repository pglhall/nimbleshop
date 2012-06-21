FactoryGirl.define do
  factory :shipment_carrier do
    sequence(:name) { |t| "UPS#{t}" }
  end
end

