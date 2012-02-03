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
