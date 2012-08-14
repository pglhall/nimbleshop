require "test_helper"

class ShippingMethodAcceptanceTest < ActionDispatch::IntegrationTest

  include ::CheckoutTestHelper

  setup do
    Capybara.current_driver = :selenium
    create(:product, name: 'Bracelet Set', price: 25)
    create(:product, name: 'Necklace Set', price: 14)
    create(:country_shipping_method, name: 'Ground Shipping', base_price: 3.99, minimum_order_amount: 1, maximum_order_amount: 99999)
    create(:country_shipping_method, name: 'Express Shipping', base_price: 13.99, minimum_order_amount: 1, maximum_order_amount: 99999)
  end

  test "shipping method is required" do
    visit root_path
    add_item_to_cart('Bracelet Set')
    click_link 'Checkout'

    enter_valid_email_address
    enter_valid_shipping_address
    click_button 'Submit'

    # Submit without choosing a shipping method
    click_button 'Submit'

    assert page.has_content?('Please select a shipping method')
  end

  test 'no shipping method available message' do
    visit root_path
    add_item_to_cart('Bracelet Set')
    click_link 'Checkout'

    enter_valid_email_address
    enter_valid_shipping_address
    ShippingMethod.delete_all
    click_button 'Submit'

    assert page.has_content?('No shipping method is available for the shipping address you have chosen')
  end

  test "ability to change shipping method" do
    visit root_path
    add_item_to_cart('Bracelet Set')
    click_link 'Checkout'

    enter_valid_email_address
    enter_valid_shipping_address
    click_button 'Submit'

    choose 'Ground Shipping'
    click_button 'Submit'

    assert_sanitized_equal 'Ground Shipping ( $3.99 )', find('.shipping-method').text
    click_link 'edit_shipping_method'

    choose 'Express Shipping'
    click_button 'Submit'

    assert_sanitized_equal 'Express Shipping ( $13.99 )', find('.shipping-method').text
  end

end
