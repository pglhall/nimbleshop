FactoryGirl.define do
  factory :address do
    sequence(:first_name) { |t| "name#{t}" }
    sequence(:last_name) { |t| "name#{t}" }
    sequence(:address1) { |t| "name#{t}" }
    sequence(:state) { |t| "name#{t}" }
    sequence(:country) { |t| "name#{t}" }
    sequence(:zipcode) { |t| "name#{t}" }
  end
end
