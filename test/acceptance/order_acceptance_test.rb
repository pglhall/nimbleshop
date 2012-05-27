require 'test_helper'

class OrderAcceptanceTest < ActionDispatch::IntegrationTest

  setup do
    @order = create(:order)
    processor = NimbleshopAuthorizedotnet::Billing.new(@order)
    playcasette('authorize.net/authorize-success') do
      processor.authorize(creditcard: build(:creditcard))
    end
  end

  test "show order" do
    visit order_path(@order)
    assert page.has_content?('Purchase is complete')
    assert page.has_content?('In the credit card statement name of the company would appear as Nimbleshop LLC')
  end

end
