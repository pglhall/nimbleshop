require "test_helper"

class ShippingAddressAcceptanceTest < ActionDispatch::IntegrationTest

  include ::ShippingMethodTestHelper
  include ::CheckoutTestHelper

  setup do
    create(:product, name: 'Bracelet Set', price: 25)
    create(:product, name: 'Necklace Set', price: 14)
    create_regional_shipping_method
  end

  test "Billing address is same as shipping address" do
    visit root_path
    add_item_to_cart('Bracelet Set')
    click_link 'Checkout'
    assert page.has_content?('Shipping address')
    enter_valid_email_address
    enter_valid_shipping_address
    click_button 'Submit'

    assert_sanitized_equal "Neeaj Singh 100 N Miami Ave Suite 500 Miami Florida 33333 United States", find('.shipping-address').text
    assert_sanitized_equal "Same as shipping address", find('.billing-address').text
  end

  test "Billing address is not same as shipping address" do
    visit root_path
    add_item_to_cart('Bracelet Set')
    click_link 'Checkout'
    enter_valid_email_address
    enter_valid_shipping_address
    uncheck 'order_shipping_address_attributes_use_for_billing'
    enter_valid_billing_address

    click_button 'Submit'

    assert_sanitized_equal "Neeaj Singh 100 N Miami Ave Suite 500 Miami Florida 33333 United States", find('.shipping-address').text
    assert_sanitized_equal "Neil Singh 100 N Pines Ave Suite 400 Pembroke Pines Florida 33332 United States", find('.billing-address').text
  end

  test 'editing shipping address' do
    visit root_path
    add_item_to_cart('Bracelet Set')
    click_link 'Checkout'
    enter_valid_email_address
    enter_valid_shipping_address
    click_button 'Submit'
    choose 'Ground'
    click_button 'Submit'
    click_link 'edit_shipping_address'
    fill_in "order_shipping_address_attributes_first_name", with: 'Neeraj1234'
    click_button 'Submit'
    assert page.has_content?('Neeraj1234')
  end

  test 'shipping_address validations' do
    visit root_path
    add_item_to_cart('Bracelet Set')
    click_link 'Checkout'

    click_button 'Submit'
    assert page.has_content?('Email is invalid')

    enter_valid_email_address
    click_button 'Submit'

    assert page.has_content?('Shipping address error !')
    assert page.has_content?("First name can't be blank")
    assert page.has_content?("Last name can't be blank")
    assert page.has_content?("Address1 can't be blank")
    assert page.has_content?("Zipcode can't be blank")
    assert page.has_content?("City can't be blank")

    enter_valid_shipping_address
    uncheck 'order_shipping_address_attributes_use_for_billing'
    click_button 'Submit'

    assert page.has_content?('Billing address error !')
    assert page.has_content?("First name can't be blank")
    assert page.has_content?("Last name can't be blank")
    assert page.has_content?("Address1 can't be blank")
    assert page.has_content?("Zipcode can't be blank")
    assert page.has_content?("City can't be blank")

    check 'order_shipping_address_attributes_use_for_billing'
    click_button 'Submit'
    assert page.has_content?("Pick shipping method")
  end
end

