class PaypalPaymentNotification < ActiveRecord::Base
  include ActiveMerchant::Billing::Integrations
  extend  ActiveSupport::Memoizable

  belongs_to :order

  delegate :acknowledge, :status, :invoice, :transaction_id, to: :notification

  before_validation :assign_order_id

  validates :order_id, presence: true
  validates :raw_post, presence: true, uniqueness: true

  def valid_transaction?
    order.total_amount.to_f.round(2) == amount
  end

  def complete
    if valid_transaction?
      order.update_attributes(payment_method: Shop.paypal_website_payments_standard)
      order.paypal_transactions.create(params: raw_post, status: status, amount: amount, txn_id: transaction_id)
      order.transaction_purchased
    end
  end

  def order
    Order.find_by_number!(assign_order_id)
  end

  def amount
    notification.amount.cents / 100.0
  end

  private

    def mark_order_as_purchased
      order.update_attribute(:purchased_at, Time.now)
    end

    def notification
      Paypal::Notification.new(raw_post)
    end

    def completed?
      status == "Completed"
    end

    def assign_order_id
      self.order_id = invoice
    end

    memoize :notification
end
