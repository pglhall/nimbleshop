require "test_helper"

class MailerTest < ActiveSupport::TestCase

  test "sends out order notification" do
    order = create(:order_with_line_items)

    mail = NimbleshopSimply::Mailer.order_notification_to_buyer(order.number)

    assert_equal "Order confirmation for order ##{order.number}", mail.subject
    assert_equal ['john@nimbleshop.com'], mail.to
    assert_match /Here is receipt for your purchase/, mail.encoded
  end

  test "sends out shipment notification" do
    order = create(:order_paid_using_authorizedotnet)

    mail = NimbleshopSimply::Mailer.shipment_notification_to_buyer(order.number)

    assert_equal "Items for order ##{order.number} have been shipped", mail.subject
    assert_equal ['john@nimbleshop.com'], mail.to
    assert_match /Items have been shipped/, mail.encoded
  end

end
