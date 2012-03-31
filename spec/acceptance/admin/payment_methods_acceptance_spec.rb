require 'spec_helper'

describe "payment_methods_acceptance_spec integration" do

  before do
    Capybara.current_driver = :selenium
  end

  describe "payment methods" do

    it "show payment_methods" do
      visit admin_path
      click_link 'Payment methods'

      assert page.has_content?("You have not configured any payment method. User wil not be able to make payment")
      page.has_content?('Setup payment method').must_equal true
      page.has_link?('Authorize.net').must_equal false
      page.has_link?('Splitable').must_equal false
      page.has_link?('Paypal website payments standard').must_equal false

      page.has_checked_field?('paypal-website-payments-standard').must_equal false
    end

    it "manages paypal" do
      visit admin_path
      click_link 'Payment methods'
      check 'paypal-website-payments-standard'

      click_link 'Edit Configuration Info'
      fill_in 'paypal_website_payments_standard_merchant_email_address', with: 'seller@bigbinary.com'
      fill_in 'paypal_website_payments_standard_return_url', with: 'http://example.com/paypal_return'
      fill_in 'paypal_website_payments_standard_notify_url', with: 'https://www.sandbox.paypal.net/cgi-bin/webscr?'
      click_button 'Submit'

      page.has_content?('Successfuly updated').must_equal true
      page.has_content?('seller@bigbinary.com').must_equal true
      page.has_content?('http://example.com/paypal_return').must_equal true
      page.has_content?('https://www.sandbox.paypal.net/cgi-bin/webscr?').must_equal true

      click_link 'Payment methods'
      page.has_checked_field?('paypal-website-payments-standard').must_equal true
      page.has_checked_field?('authorize-net').must_equal false
      page.has_checked_field?('splitable').must_equal false

      page.has_link?('Authorize.net').must_equal false
      page.has_link?('Splitable').must_equal false
      page.has_link?('Paypal website payments standard').must_equal true
    end

    it "manages authorize.net" do
      visit admin_path
      click_link 'Payment methods'
      check 'authorize-net'

      click_link 'Edit Configuration Info'
      fill_in 'Authorize net login', with: '9r3pbDFGDFoihj29f7d'
      click_button 'Submit'

      page.has_content?('Successfuly updated').must_equal true
      page.has_content?('9r3pbDFGDFoihj29f7d').must_equal true

      click_link 'Payment methods'
      page.has_checked_field?('paypal-website-payments-standard').must_equal false
      page.has_checked_field?('authorize-net').must_equal true
      page.has_checked_field?('splitable').must_equal false

      page.has_link?('Authorize.net').must_equal true
      page.has_link?('Splitable').must_equal false
      page.has_link?('Paypal website payments standard').must_equal false
    end

  end
end
