require 'spec_helper'

describe "checkout_spec integration" do
  include RegionalShippingMethodTestHelper
  include AddressSpecHelper

  before do
    Capybara.current_driver  = :selenium
    create(:product, name: 'Bracelet Set', price: 25)
    create(:product, name: 'Necklace Set', price: 14)
    create_regional_shipping_method
    create(:payment_method, enabled: true)
  end

  describe "when admin has not enabled any payment method then there should not be any error" do
    it {
      visit root_path
      add_item_to_cart('Bracelet Set')
      click_button 'Checkout'
      fill_in 'Your email address', with: 'test@example.com'
      fill_good_address
      click_button 'Submit'
      choose 'Ground'
      click_button 'Submit'
      assert page.has_content?('All payments are secure and encrypted.')
    }
  end

  describe "when current order expired" do
    before do
      visit root_path
      add_item_to_cart('Bracelet Set')
      click_button 'Checkout'
    end

    it "must redirect to home page" do
      Order.last.destroy
      visit current_path
      current_path.must_equal("/")
    end

    it "must redirect from shipping method page to home page" do
      fill_in 'Your email address', with: 'test@example.com'

      fill_good_address
      click_button 'Submit'
      Order.last.destroy
      visit current_path
      current_path.must_equal("/")
    end
  end


  let(:current_order) { Order.last }

  describe "should be able to add one item to cart" do
    it {
      visit root_path
      add_item_to_cart('Bracelet Set')
      page.has_content?('Your cart').must_equal true
      page.has_content?('1 Item').must_equal true
      page.has_content?('$25').must_equal true
      page.has_no_css?('table tr.shipping_cost')
    }
  end

  describe "should be able to add two items to cart" do
    it {
      visit root_path
      add_item_to_cart('Bracelet Set')
      visit root_path
      add_item_to_cart 'Necklace Set'
      assert page.has_content?('2 Items')
      assert page.has_content?('$39')
    }
  end

  describe "should be able to increase the quantity of items in the cart" do
    it {
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
    }
  end

  describe "Billing address not same as shipping address" do
    it {
      visit root_path
      add_item_to_cart('Bracelet Set')
      click_button 'Checkout'
      page.has_content?('Shipping information')
      fill_in 'Your email address', with: 'test@example.com'
      fill_good_address

      uncheck 'order_shipping_address_attributes_use_for_billing'
      billing_address = build(:billing_address)
      complete_address_form('billing', billing_address)
      click_button 'Submit'

      assert page.has_content?('$3.99')
      page.has_content?('Pick shipping method')

      # Biling address should not be same as shipping address
      refute page.has_content?('Same as shipping address')

      assert page.has_content?(billing_address[:address1])
      assert page.has_content?(billing_address[:city])
    }
  end

  describe "Billing address same as shipping address" do
    it {
      visit root_path
      add_item_to_cart('Bracelet Set')
      click_button 'Checkout'
      page.has_content?('Shipping information')
      fill_in 'Your email address', with: 'test@example.com'
      fill_good_address

      click_button 'Submit'

      assert page.has_content?('Ground -- $3.99')
      assert page.has_content?('Pick shipping method')

      # Biling address should not be same as shipping address
      assert page.has_content?('Same as shipping address')

      assert page.has_content?('$25.00')
      assert page.has_content?('Bracelet Set')
    }
  end

  describe "Edit shipping address" do
    it {
      visit root_path
      add_item_to_cart('Bracelet Set')
      click_button 'Checkout'
      fill_in 'Your email address', with: 'test@example.com'
      fill_good_address

      click_button 'Submit'

      choose 'Ground'
      click_button 'Submit'

      click_link 'edit_shipping_address'
      assert current_path == edit_order_path(current_order)

      check 'order_shipping_address_attributes_use_for_billing'
      click_button 'Submit'
      assert page.has_content?('Same as shipping address')
    }
  end

  describe "Edit shipping method" do
    it {
      visit root_path
      add_item_to_cart('Bracelet Set')
      click_button 'Checkout'
      fill_in 'Your email address', with: 'test@example.com'
      fill_good_address

      click_button 'Submit'

      choose 'Ground'
      click_button 'Submit'

      click_link 'edit_shipping_method'
      assert current_path == edit_shipping_method_order_path(current_order)
    }
  end

  describe "delete a product and change the quantity in the cart" do
    it {
      visit root_path
      add_item_to_cart('Bracelet Set')
      click_button 'Checkout'
      fill_in 'Your email address', with: 'test@example.com'
      fill_good_address

      click_button 'Submit'

      choose 'Ground'
      click_button 'Submit'

      # if product is deleted and update is clicked then it should work
      click_link 'edit_cart'
      assert current_path == cart_path

      p = Product.find_by_name('Bracelet Set')
      p.destroy
      fill_in "updates_#{p.id}", with: '10'
      click_button 'Update'
      assert page.has_content?('$250.00')
      assert page.has_css?('table tr.shipping_cost')

      click_button 'Checkout'
      assert page.has_content?('Shipping information')
    }
  end

  describe "shipping addess error validations" do
    it {
      visit root_path
      click_link 'Bracelet Set'
      click_button 'Add to cart'
      click_button 'Checkout'

      fill_in 'Your email address', with: ''
      click_button 'Submit'
      assert page.has_content?('Email is invalid')

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

      assert page.has_content?('Shipping address error !')
      address_errors

      fill_good_address
      uncheck 'order_shipping_address_attributes_use_for_billing'
      click_button 'Submit'

      assert page.has_content?('Billing address error !')
      address_errors

      check 'order_shipping_address_attributes_use_for_billing'
      click_button 'Submit'
    }
  end

  private

  def address_errors
    assert page.has_content?("First name can't be blank")
    assert page.has_content?("Last name can't be blank")
    assert page.has_content?("Address1 can't be blank")
    assert page.has_content?("Zipcode can't be blank")
    assert page.has_content?("City can't be blank")
  end

  def add_item_to_cart(name)
    click_link name
    click_button 'Add to cart'
  end
end
