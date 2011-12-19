FactoryGirl.define do
  factory :product_group do
    sequence(:name) { |t| "name#{t}" }
    condition { {} }
  end
end
