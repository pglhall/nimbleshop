require 'spec_helper'

describe "checkout integration" do
  include RegionalShippingMethodTestHelper

  before do
    Capybara.current_driver  = :selenium
    create(:product, name: 'Candy Colours Bracelet Set', price: 25)
    create(:product, name: 'Layered Coral Necklace', price: 14)
    create_regional_shipping_method
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
    fill_in 'order_billing_address_attributes_zipcode', with: '544355'
    select 'United States', from: 'order_billing_address_attributes_country_code'
    select   'Alabama', from: 'order_billing_address_attributes_state_code'

    click_button 'Submit'

    page.has_content?('$3.99').must_equal true
    choose 'Ground'
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

    # if product is deleted and update is clicked then it should work
    click_link 'edit_cart'
    assert current_path == cart_path

    p = Product.find_by_name('Candy Colours Bracelet Set')
    p.destroy
    fill_in "updates_#{p.id}", with: '10'
    click_button 'Update'
    assert page.has_content?('$250.00')

    click_button 'Checkout'

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
    fill_in 'Zipcode', with: ''
    select  '', :from => 'Country code'
    select  '', :from => 'State code'
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
    #page.has_content?("Please select a shipping method").must_equal true

  end

  private

  def address_errors
    page.has_content?("First name can't be blank").must_equal true
    page.has_content?("Last name can't be blank").must_equal true
    page.has_content?("Address1 can't be blank").must_equal true
    page.has_content?("Zipcode can't be blank").must_equal true
    page.has_content?("City can't be blank").must_equal true
  end

  def fill_good_address
    fill_in 'First name', with: 'Jack'
    fill_in 'Last name', with: 'Daniels'
    fill_in 'Address1', with: '182 Lynchburg'
    fill_in 'Address2', with: 'Highway'
    fill_in 'City', with: 'Lynchburg'
    select  'United States', :from => 'Country code'
    select  'Alabama', :from => 'State code'
    fill_in 'Zipcode', with: '37352'
  end
end
