FactoryGirl.define do
  factory :product do
    sequence(:name) { |t| "name#{t}" }
    sequence(:description) { |t| "description#{t}" }
    price { rand * 100 }
  end
end
