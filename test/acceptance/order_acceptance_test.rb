require 'test_helper'

class OrderAcceptanceTest < ActionDispatch::IntegrationTest

  setup do
    @order = create :order_paid_using_authorizedotnet
  end

  test "show order when it was paid using authorizedotnet" do
    visit order_path(@order)
    assert page.has_content?('Purchase is complete')
    assert page.has_content?('In the credit card statement name of the company would appear as Nimbleshop LLC')
  end

end
