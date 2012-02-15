require 'spec_helper'

describe "checkout integration" do

  before do
    create(:product, name: 'Candy Colours Bracelet Set', price: 25)
    create(:product, name: 'Layered Coral Necklace', price: 14)
    create(:regional_shipping_zone)
    create(:regional_shipping_method)
    create(:regional_shipping_method, base_price: 3.99, lower_price_limit: 1, upper_price_limit: 99999)
    create(:payment_method, enabled: true)
  end

  let(:current_order) { Order.last }

  it "should be ok for good path" do
    visit root_path
    click_link 'Candy Colours Bracelet Set'

    click_button 'Add to cart'
    page.has_content?('Your cart').must_equal true
    page.has_content?('1 Item').must_equal true
    page.has_content?('$25').must_equal true

    visit root_path
    click_link 'Layered Coral Necklace'
    click_button 'Add to cart'

    page.has_content?('2 Items').must_equal true
    page.has_content?('$39').must_equal true

    p1 = Product.find_by_name 'Candy Colours Bracelet Set'
    p2 = Product.find_by_name 'Layered Coral Necklace'

    fill_in "updates_#{p1.id}", with: '4'
    fill_in "updates_#{p2.id}", with: '2'

    click_button 'Update'
    page.has_content?('$128').must_equal true

    click_button 'Checkout'
    fill_in 'Your email address', with: 'test@example.com'
    fill_good_address

    uncheck 'order_shipping_address_attributes_use_for_billing'
    fill_in 'order_billing_address_attributes_first_name', with: 'John'
    fill_in 'order_billing_address_attributes_last_name', with: 'Smith'
    fill_in 'order_billing_address_attributes_address1', with: 'Pleasant Street'
    fill_in 'order_billing_address_attributes_address2', with: '69'
    fill_in 'order_billing_address_attributes_city', with: 'New York'
    fill_in 'order_billing_address_attributes_state_code', with: 'AL'
    fill_in 'order_billing_address_attributes_zipcode', with: '544355'
    fill_in 'order_billing_address_attributes_country_code', with: 'US'

    click_button 'Submit'

    page.has_content?('$3.99').must_equal true
    choose '3.99'

    click_button 'Submit'
    page.has_content?('Same as shipping address').must_equal false

    page.has_content?('$131.99').must_equal true
    page.has_content?('Candy Colours Bracelet Set').must_equal true
    page.has_content?('Layered Coral Necklace').must_equal true
    page.has_content?('Pleasant Street').must_equal true
    page.has_content?('182 Lynchburg').must_equal true
    page.has_content?('$3.99').must_equal true
    page.has_content?('test@example.com').must_equal true

    click_link 'edit_shipping_address'
    assert current_path == edit_order_path(current_order)

    check 'order_shipping_address_attributes_use_for_billing'
    click_button 'Submit'
    click_button 'Submit'
    page.has_content?('Same as shipping address').must_equal true

    #TODO admin delete, product still present on cart
    skip do
      Product.find_by_name('Candy Colours Bracelet Set').destroy
      click_link 'edit_cart'
      assert current_path == cart_path
      fill_in 'updates_candy-colours-bracelet-set', with: '8'

      click_button 'Checkout'
      assert page.has_content?('$231.99')
    end

    click_link 'edit_shipping_method'
    assert current_path == edit_shipping_method_order_path(current_order)

  end

  it "should not be ok for wrong path" do
    visit root_path
    click_link 'Candy Colours Bracelet Set'
    click_button 'Add to cart'
    click_button 'Checkout'

    fill_in 'Your email address', with: ''
    click_button 'Submit'
    page.has_content?('Email is invalid').must_equal true

    fill_in 'Your email address', with: 'test@example.com'
    fill_in 'First name', with: ''
    fill_in 'Last name', with: ''
    fill_in 'Address1', with: ''
    fill_in 'Address2', with: ''
    fill_in 'City', with: ''
    fill_in 'State code', with: ''
    fill_in 'Zipcode', with: ''
    fill_in 'Country code', with: ''
    click_button 'Submit'

    page.has_content?('Shipping address error !').must_equal true
    address_errors

    fill_good_address
    uncheck 'order_shipping_address_attributes_use_for_billing'
    click_button 'Submit'

    page.has_content?('Billing address error !').must_equal true
    address_errors

    check 'order_shipping_address_attributes_use_for_billing'
    click_button 'Submit'

    #do not choose shipping method
    click_button 'Submit'
    page.has_content?("Please select a shipping method").must_equal true

  end

  private

  def address_errors
    page.has_content?("First name can't be blank").must_equal true
    page.has_content?("Last name can't be blank").must_equal true
    page.has_content?("Address1 can't be blank").must_equal true
    page.has_content?("Zipcode can't be blank").must_equal true
    page.has_content?("Country code is not a valid country code").must_equal true
    page.has_content?("City can't be blank").must_equal true
  end

  def fill_good_address
    fill_in 'First name', with: 'Jack'
    fill_in 'Last name', with: 'Daniels'
    fill_in 'Address1', with: '182 Lynchburg'
    fill_in 'Address2', with: 'Highway'
    fill_in 'City', with: 'Lynchburg'
    fill_in 'State code', with: 'AL'
    fill_in 'Zipcode', with: '37352'
    fill_in 'Country code', with: 'US'
  end

end
