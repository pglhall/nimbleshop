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
      assert page.has_content?('Setup payment method')
      refute page.has_link?('Authorize.net')
      refute page.has_link?('Splitable')
      refute page.has_link?('Paypal website payments standard')

      refute page.has_checked_field?('paypal-website-payments-standard')
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
