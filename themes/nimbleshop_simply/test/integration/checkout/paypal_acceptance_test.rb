require "test_helper"

class PaypalAcceptanceTest < ActionDispatch::IntegrationTest

  include ::ShippingMethodTestHelper
  include ::CheckoutTestHelper

  setup do
    create(:product, name: 'Bracelet Set', price: 25)
    create(:product, name: 'Necklace Set', price: 14)
    create_regional_shipping_method
  end

  test 'paypal variables' do
    visit root_path
    add_item_to_cart('Bracelet Set')
    assert_sanitized_equal "Total: $25.00", find('.line-items-total').text

    click_link 'Checkout'

    enter_valid_email_address
    enter_valid_shipping_address

    click_button 'Submit'

    choose 'Ground'
    click_button 'Submit'

    assert_sanitized_equal 'Total: $29.30', find('.order-total-amount').text
    assert_sanitized_equal "25.0", page.find("#amount_1").value
    assert_sanitized_equal "3.99", page.find("#handling_cart").value
    assert_sanitized_equal "0.31", page.find("#tax_cart").value
  end
end
