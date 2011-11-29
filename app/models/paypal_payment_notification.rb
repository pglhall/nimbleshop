class PaypalPaymentNotification < ActiveRecord::Base

  serialize :params
  after_create :mark_order_as_purchased

  def order
    Order.find_by_order_number(self.order_number)
  end

  private

  def mark_order_as_purchased
    if status == "Completed"
      order.update_attribute(:purchased_at, Time.now)
    end
  end

end
