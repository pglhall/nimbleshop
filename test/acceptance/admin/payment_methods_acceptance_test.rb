require "test_helper"

class PaymentMethodsAcceptanceTest < ActionDispatch::IntegrationTest

  fixtures :payment_methods

  setup do
    Capybara.current_driver = :selenium
  end

  test "show payment_methods" do
    PaymentMethod.delete_all
    visit admin_path
    click_link 'Payment methods'

    assert page.has_content?("You have not configured any payment method. User wil not be able to make payment")
    assert page.has_content?('Setup payment method')
    refute page.has_link?('Authorize.net')
    refute page.has_link?('Splitable')
    refute page.has_link?('Paypal website payments standard')

    refute page.has_checked_field?('paypal-website-payments-standard')
  end

  test "manages authorize.net" do
    skip 'look into why fixture is not being loaded' do
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
