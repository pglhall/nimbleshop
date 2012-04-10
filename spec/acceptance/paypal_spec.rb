require "test_helper"

class PaypalIntegrationTest < ActionDispatch::IntegrationTest

  def add_item_to_cart(name)
    click_link name
    click_button 'Add to cart'
  end

  def fill_good_address
    address = build(:shipping_address)
    fill_in 'First name',     with: address[:first_name]
    fill_in 'Last name',      with: address[:last_name]
    fill_in 'Address1',       with: address[:address1]
    fill_in 'Address2',       with: 'Highway'
    fill_in 'City',           with: address[:city]
    select  'United States',  from: 'Country'
    select  'Alabama',        from: 'State'
    fill_in 'Zipcode',        with:  address[:zipcode]
  end

  setup do
    Capybara.current_driver = :selenium

    paypal = PaymentMethod.find_by_permalink("paypal-website-payments-standard")
    paypal.update_column(:enabled, true)
    create(:product, name: 'Bracelet Set', price: 25)
    create(:product, name: 'Necklace Set', price: 14)
    create(:country_shipping_method, name: 'Ground', base_price: 3.99, lower_price_limit: 1, upper_price_limit: 99999)
    create(:payment_method, enabled: true)

    visit root_path
    add_item_to_cart('Bracelet Set')
    click_button 'Checkout'
    fill_in 'Your email address', with: 'test@example.com'
    fill_good_address
    click_button 'Submit'
    choose 'Ground'
    click_button 'Submit'

  end

  test 'paypal variables' do
    assert_equal page.find("#amount_1").value, "25.0"
    #assert_equal page.find("#amount_2").value, "14.0"
    assert_equal page.find("#handling_cart").value, "3.99"
    assert_equal page.find("#tax_cart").value, "0.31"
  end
end

