require "test_helper"

class AuthorizeNetAcceptanceTest < ActionDispatch::IntegrationTest

  include ::ShippingMethodSpecHelper
  include ::CheckoutTestHelper

  setup do
    paypal = NimbleshopPaypalwp::Paypalwp.first.enable!

    create(:product, name: 'Bracelet Set', price: 25)
    create(:product, name: 'Necklace Set', price: 14)

    create_regional_shipping_method

    create(:payment_method, enabled: true)

    visit root_path
    add_item_to_cart('Bracelet Set')
    click_button 'Checkout'
    enter_valid_email_address
    enter_valid_shipping_address
    click_button 'Submit'
    choose 'Ground'
    click_button 'Submit'
  end

  test 'when credit card invalid' do
    skip 'credit card invalid message is using alert' do
      click_button 'Submit'
      assert page.has_content?("Credit card number is blank")
    end
  end
end

