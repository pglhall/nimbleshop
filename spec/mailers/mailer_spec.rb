require "test_helper"

class MailerTest < ActiveSupport::TestCase
  setup do
    @order = create(:order_with_line_items)
    creditcard_transaction = build(:creditcard_transaction, order: @order)
    creditcard_transaction.save(validate: false)
  end

  test "sends out order notification" do
    @order.line_items.count.must_equal 1
    mail = Mailer.order_notification(@order.number)
    mail.subject.must_equal "Order confirmation for order ##{@order.number}"
    mail.to.must_equal ['john@nimbleshop.com']
    mail.encoded.must_match /Here is receipt for your purchase/
  end

end

