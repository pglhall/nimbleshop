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

    trait :paypalwp do
      payment_method_id 3
    end


    factory :order_with_line_items,   traits: [:line_items]

    factory :order_paid_using_authorizedotnet,   traits: [:authorizedotnet] do |order|
      order.after_create do |o|
        create :payment_transaction_with_authorizedotnet, order: o
      end
    end

    factory :order_paid_using_paypalwp,   traits: [:paypalwp] do |order|
      order.after_create do |o|
        create :payment_transaction_with_paypalwp, order: o
      end
    end



  end
end
