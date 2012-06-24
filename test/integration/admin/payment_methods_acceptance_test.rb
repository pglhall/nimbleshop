require "test_helper"

class PaymentMethodsAcceptanceTest < ActionDispatch::IntegrationTest

  test "payment_methods when no payment method is configured" do
    PaymentMethod.delete_all
    visit admin_path
    click_link 'Payment methods'

    assert page.has_content?("You have not setup any payment method. User wil not be able to make payment")
  end

end
