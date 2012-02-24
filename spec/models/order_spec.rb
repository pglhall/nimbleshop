require 'spec_helper'

describe Order do

  describe "#after_authorized" do
    it {
      order = create(:order)
      create(:creditcard_transaction, order: order)
      order.authorized
      order.payment_status.must_equal 'authorized'
      ActionMailer::Base.deliveries.size.must_equal 2

      mail = ActionMailer::Base.deliveries.first
      mail.subject.must_equal "Order confirmation for order ##{order.number}"
      mail.encoded.must_match /Here is receipt for your purchase/
      mail.encoded.must_match /When items are shipped you will get an email with tracking number/

      mail = ActionMailer::Base.deliveries.last
      mail.subject.must_equal "Order ##{order.number} was recetly placed"
      mail.encoded.must_match Regexp.new("Order ##{order.number} was placed by")
    }
  end

end
