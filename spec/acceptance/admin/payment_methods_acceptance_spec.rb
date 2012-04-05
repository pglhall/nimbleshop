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
      assert page.has_content?('Setup payment method').must_equal true
      refute page.has_link?('Authorize.net')
      refute page.has_link?('Splitable')
      refute page.has_link?('Paypal website payments standard')

      refute page.has_checked_field?('paypal-website-payments-standard')
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

      skip "Subba will look into this paypal spec issue" do
      assert page.has_content?('Successfuly updated')
      assert page.has_content?('seller@bigbinary.com')
      assert page.has_content?('http://example.com/paypal_return')
      assert page.has_content?('https://www.sandbox.paypal.net/cgi-bin/webscr?')

      click_link 'Payment methods'
      assert page.has_checked_field?('paypal-website-payments-standard')
      refute page.has_checked_field?('authorize-net')
      refute page.has_checked_field?('splitable')

      refute page.has_link?('Authorize.net')
      refute page.has_link?('Splitable')
      assert page.has_link?('Paypal website payments standard')
      end
    end

    it "manages authorize.net" do
      visit admin_path
      click_link 'Payment methods'
      check 'authorize-net'

      click_link 'Edit Configuration Info'
      fill_in 'Authorize net login', with: '9r3pbDFGDFoihj29f7d'
      click_button 'Submit'

      assert page.has_content?('Successfuly updated')
      assert page.has_content?('9r3pbDFGDFoihj29f7d')

      click_link 'Payment methods'
      refute page.has_checked_field?('paypal-website-payments-standard')
      assert page.has_checked_field?('authorize-net')
      refute page.has_checked_field?('splitable')

      assert page.has_link?('Authorize.net')
      refute page.has_link?('Splitable')
      refute page.has_link?('Paypal website payments standard')
    end

  end
end
