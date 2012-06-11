module CheckoutTestHelper

  def add_item_to_cart(name)
    click_link name
    click_button 'Add to cart'
  end

  def enter_valid_email_address
    fill_in 'Your email address', with: 'john@example.com'
  end

  def enter_valid_shipping_address
    {first_name: 'Neeaj',
     last_name: 'Singh', 
     address1: '100 N. Miami Ave', 
     address2: 'Suite #500',
     city: 'Miami', 
     zipcode: '33333'}.each do |key, value|
      fill_in "order_shipping_address_attributes_#{key}", with: value
    end

    select  'United States',  from: "order_shipping_address_attributes_country_code"
    select  'Florida',        from: "order_shipping_address_attributes_state_code"
  end

  def enter_valid_billing_address
    {first_name: 'Neil', 
     last_name: 'Singh', 
     address1: '100 N. Pines Ave', 
     address2: 'Suite #400',
     city: 'Pembroke Pines', 
     zipcode: '33332'}.each do |key, value|
      fill_in "order_billing_address_attributes_#{key}", with: value
    end

    select  'United States',  from: "order_billing_address_attributes_country_code"
    select  'Florida',        from: "order_billing_address_attributes_state_code"
  end

end
