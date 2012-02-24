FactoryGirl.define do
  factory :order do |f|
    email 'john@nimbleshop.com'
    shipping_address
    association :shipping_method, factory: :country_shipping_method
    sequence(:number) { |t| "xxx#{t}" }

  end
end

def order_with_line_items
  order = create(:order)
  create(:line_item, order: order)
  order
end

def order_with_authorized_transaction
  order = create(:order)
  create(:creditcard_transaction, order: order)
  order.update_attributes!(payment_method: PaymentMethod::AuthorizeNet.first)
  order
end
