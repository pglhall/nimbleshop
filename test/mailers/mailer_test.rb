require "test_helper"

class MailerTest < ActiveSupport::TestCase
  setup do
    @order = create(:order_with_line_items)
  end

  test "sends out order notification" do
    assert_equal 1, @order.line_items.count
    mail = Mailer.order_notification(@order.number)
    assert_equal "Order confirmation for order ##{@order.number}", mail.subject
    assert_equal ['john@nimbleshop.com'], mail.to
    assert_match /Here is receipt for your purchase/, mail.encoded
  end

end

