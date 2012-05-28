FactoryGirl.define do
  factory :order do |f|
    email 'john@nimbleshop.com'
    shipping_address
    association :shipping_method, factory: :country_shipping_method
    sequence(:number) { |t| "xxx#{t}" }

    trait :line_items do
      after(:create) { | r | FactoryGirl.create(:line_item, order: r) }
    end

    factory :order_with_line_items,   traits: [:line_items]
  end
end
