require "test_helper"

class PaymentMethodsAcceptanceTest < ActionDispatch::IntegrationTest
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
    visit admin_path
    click_link 'Payment methods'
    click_link 'Authorize.net'

    click_link 'Edit Configuration Info'
    fill_in 'Login', with: '9r3pbDFGDFoihj29f7d'
    click_button 'Submit'

    assert page.has_content?('Successfuly updated')
    assert page.has_content?('9r3pbDFGDFoihj29f7d')
  end
end
