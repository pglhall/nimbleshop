FactoryGirl.define do
  factory :order do |f|
    email 'john@nimbleshop.com'
    shipping_address
    association :shipping_method, factory: :country_shipping_method
    sequence(:number) { |t| "xxx#{t}" }

    trait :line_items do
      after(:create) { | r | FactoryGirl.create(:line_item, order: r) }
    end

    trait :authorizedotnet do
      payment_method_id 2
    end

    factory :order_with_line_items,   traits: [:line_items]

    factory :order_paid_using_authorizedotnet,   traits: [:authorizedotnet]

  end
end
