require "test_helper"

class CartAcceptanceTest < ActionDispatch::IntegrationTest

  include ::ShippingMethodTestHelper
  include ::CheckoutTestHelper

  setup do
    create(:product, name: 'Bracelet Set', price: 25)
    create(:product, name: 'Necklace Set', price: 14)
    create_regional_shipping_method
  end

  test "after going all the way to checkout if buyer comes back to cart only line items amount should be shown" do
    visit root_path
    add_item_to_cart('Bracelet Set')
    assert_equal "Total: $25.00", find('.line-items-total').text.chomp.strip

    click_link 'Checkout'

    enter_valid_email_address
    enter_valid_shipping_address

    click_button 'Submit'

    choose 'Ground'
    click_button 'Submit'

    assert_sanitized_equal 'Total: $29.30', find('.order-total-amount').text
    click_link 'edit_cart'

    assert_sanitized_equal "Total: $25.00", find('.line-items-total').text
  end

  test "should be able to change the quantity even if product is deleted" do
    visit root_path
    add_item_to_cart('Bracelet Set')

    p = Product.find_by_name('Bracelet Set')
    fill_in "updates_#{p.id}", with: '10'
    p.destroy
    click_button 'Update'
    assert_sanitized_equal "Total: $250.00", find('.line-items-total').text
  end

  test "should be able to increase the quantities of items in the cart" do
    visit root_path
    add_item_to_cart('Bracelet Set')
    visit root_path
    add_item_to_cart 'Necklace Set'
    p1 = Product.find_by_name 'Bracelet Set'
    p2 = Product.find_by_name 'Necklace Set'

    fill_in "updates_#{p1.id}", with: '4'
    fill_in "updates_#{p2.id}", with: '2'

    click_button 'Update'
    assert page.has_content?('$128')
  end

  test "when admin has not setup any payment method then there should not be any error" do
    PaymentMethod.delete_all
    visit root_path
    add_item_to_cart('Bracelet Set')
    click_link 'Checkout'
    enter_valid_email_address
    enter_valid_shipping_address
    click_button 'Submit'
    choose 'Ground'
    click_button 'Submit'
    assert page.has_content?('No payment method has been setup. Please setup atleast one payment method.')
  end

  test "should be able to add 2 items to cart and title should be reflect that" do
    visit root_path
    add_item_to_cart('Bracelet Set')
    visit root_path
    add_item_to_cart 'Necklace Set'
    assert page.has_content?('2 Items')
    assert page.has_content?('$39')
  end
end

class CartWithOrderExpiredAcceptanceTest < ActionDispatch::IntegrationTest

  include ::ShippingMethodTestHelper
  include ::CheckoutTestHelper

  setup do
    create(:product, name: 'Bracelet Set', price: 25)
    create(:product, name: 'Necklace Set', price: 14)
    create(:country_shipping_method)
  end

  test 'on cart page' do
    visit root_path
    add_item_to_cart('Bracelet Set')
    click_link 'Checkout'
    Order.last.destroy
    click_link 'edit_cart'
    assert page.has_content?('powered by')
  end

  test 'on shipping address page' do
    visit root_path
    add_item_to_cart('Bracelet Set')
    assert page.has_css?('.line-items-total', text: '$25.00')
    click_link 'Checkout'
    Order.last.destroy
    visit current_path
    assert page.has_content?('powered by')
  end
end

class CartWithOrderAlreadyAuthorizedAcceptanceTest < ActionDispatch::IntegrationTest
  include ::ShippingMethodTestHelper
  include ::CheckoutTestHelper

  setup do
    create(:product, name: 'Bracelet Set', price: 25)
    create(:product, name: 'Necklace Set', price: 14)
    create(:country_shipping_method)
  end

  test 'on cart page' do
    visit root_path
    add_item_to_cart('Bracelet Set')
    assert_equal 1, Order.last.line_items.size
    old_order_id = Order.last.id
    Order.last.update_column(:payment_status, 'authorized')
    add_item_to_cart('Bracelet Set')
    assert_equal 1, Order.last.line_items.size
    refute old_order_id == Order.last.id
  end

end
