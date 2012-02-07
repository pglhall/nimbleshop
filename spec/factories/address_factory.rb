FactoryGirl.define do
  factory :address do
    country_code 'US'
    state_code 'FL'
    state_name 'Florida'
    city 'Miami'
    sequence(:first_name) { |t| "name#{t}" }
    sequence(:last_name) { |t| "name#{t}" }
    sequence(:address1) { |t| "name#{t}" }
    sequence(:zipcode) { |t| "name#{t}" }
  end
end

FactoryGirl.define do
  factory :shipping_address do
    country_code 'US'
    state_code 'FL'
    state_name 'Florida'
    city 'Miami'
    sequence(:first_name) { |t| "name#{t}" }
    sequence(:last_name) { |t| "name#{t}" }
    sequence(:address1) { |t| "name#{t}" }
    sequence(:zipcode) { |t| "name#{t}" }
  end
end
