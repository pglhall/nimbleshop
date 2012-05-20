require "test_helper"

class PaymentMethodsAcceptanceTest < ActionDispatch::IntegrationTest

  test "payment_methods when no payment method is configured" do
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

  test "manage authorize.net" do
    visit admin_path
    click_link 'Payment methods'
    click_link 'Authorize.net'

    click_link 'Edit Configuration Info'
    fill_in 'authorizedotnet_login_id', with: '9r3pbDFGDFoihj29f7d'
    click_button 'Submit'

    assert page.has_content?('Authorize.net record was successfuly updated')
    assert page.has_content?('9r3pbDFGDFoihj29f7d')
  end

  test "manage paypal" do
    visit admin_path
    click_link 'Payment methods'
    click_link 'Paypal website payments standard'

    click_link 'Edit Configuration Info'
    fill_in 'paypalwp_merchant_email', with: 'sarah@example.com'
    click_button 'Submit'

    assert page.has_content?('Paypal record was successfully updated')
    assert page.has_content?('sarah@example.com')
  end

  test "manage splitable" do
    visit admin_path
    click_link 'Payment methods'
    click_link 'Splitable'

    click_link 'Edit Configuration Info'
    fill_in 'splitable_api_key', with: 'qwerty'
    click_button 'Submit'

    assert page.has_content?('Splitable record was successfully updated')
    assert page.has_content?('qwerty')
  end
end
