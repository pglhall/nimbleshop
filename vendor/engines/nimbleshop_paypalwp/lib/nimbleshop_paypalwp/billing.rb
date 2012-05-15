module NimbleshopPaypalwp
  class Billing < Billing::Base
    attr_reader :order

    def initialize(options = {})
      @paypal_ipn = paypal_ipn(options[:raw_post])
      @order = Order.find(@paypal_ipn.invoice)
    end

    private

    def do_capture(options={})
      succeded = amount_match?
      add_to_order('captured', success: succeded)

      if succeded
        order.update_attributes(paid_at: paid_at, payment_method: Shop.paypal_website_payments_standard)
        order.kapture
      end

      succeded
    end

    def do_authorize(options={})
      succeded = amount_match?
      add_to_order('authorized', success: succeded)

      if succeded
        order.update_attributes(paid_at: paid_at, payment_method: Shop.paypal_website_payments_standard)
        order.authorize
      end

      succeded
    end

    def do_void(options={})
    end

    def do_purchase(options={})
      succeded = amount_match?
      add_to_order('purchased', success: succeded)

      if succeded
        order.update_attributes(paid_at: @paypal_ipn.received_at,
                                payment_method: Shop.paypal_website_payments_standard)
        order.purchase
      end

      succeded
    end

    def paypal_ipn(raw_post)
      ActiveMerchant::Billing::Integrations::Paypal::Notification.new(raw_post)
    end

    def add_to_order(operation, options = {})
      order.payment_transactions.create(options.merge(amount: @paypal_ipn.amount.cents,
                                                      params: { :ipn => @paypal_ipn.raw },
                                                      transaction_gid: @paypal_ipn.transaction_id,
                                                      operation: operation))

    end

    def amount_match?
      @paypal_ipn.amount.cents == order.total_amount_in_cents
    end

    def acknowledge
      @paypal_ipn.acknowledge
    end

    def paid_at
      Time.strptime(@paypal_ipn.params['payment_date'], "%H:%M:%S %b %d, %Y %z")
    end
  end
end
