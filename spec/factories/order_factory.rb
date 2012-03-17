FactoryGirl.define do
  factory :order do |f|
    email 'john@nimbleshop.com'
    shipping_address
    association :shipping_method, factory: :country_shipping_method
    sequence(:number) { |t| "xxx#{t}" }

    trait :line_items do
      after_create { | r | Factory.create(:line_item, order: r) }
    end

    trait :with_credittransaction do
      after_create do | order |
        Factory.create(:creditcard_transaction, order: order)
        order.update_attributes(payment_method: PaymentMethod::AuthorizeNet.first)
      end
    end

    trait :authorized do
      after_create { | r | r.transaction_authorized }
    end

    trait :captured do
      after_create { | r | r.transaction_captured }
    end

    trait :cancelled do
      after_create { | r | r.transaction_captured }
    end

    factory :order_with_line_items,   traits: [:line_items]
    factory :order_with_transaction,  traits: [:with_credittransaction]
    factory :authorized_order,        traits: [:with_credittransaction, :authorized]
    factory :captured_order,          traits: [:with_credittransaction, :authorized, :captured]
  end
end
