FactoryGirl.define do
  factory :product do
    sequence(:name) { |t| "name#{t}" }
    sequence(:description) { |t| "description#{t}" }
    price 50
  end
end
