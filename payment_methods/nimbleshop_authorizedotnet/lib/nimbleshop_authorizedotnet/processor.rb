module NimbleshopAuthorizedotnet
  module Util
    extend self

    def billing_address(order)
      { address1: order.real_billing_address.address1,
        city: order.real_billing_address.city,
        state: order.real_billing_address.state_name,
        country: order.real_billing_address.country_name,
        zip: order.real_billing_address.zipcode }
    end

    def shipping_address(order)
      { first_name: order.shipping_address.first_name,
        last_name: order.shipping_address.last_name,
        address1: order.shipping_address.address1,
        city: order.shipping_address.city,
        state: order.shipping_address.state_name,
        country: order.shipping_address.country_name,
        zip: order.shipping_address.zipcode }
    end

    def am_options(order)
      billing_address = { billing_address: billing_address(order) }
      shipping_address = { shipping_address: shipping_address(order) }
      misc = { order_id: order.number, email: order.email }
      billing_address.merge(shipping_address).merge(misc)
    end
  end

  class Processor < Processor::Base

    attr_reader :order, :payment_method, :errors

    def gateway
      ::NimbleshopAuthorizedotnet::Gateway.instance
    end

    def initialize(order)
      @errors = []
      @order = order
      @payment_method = NimbleshopAuthorizedotnet::Authorizedotnet.first
    end

    private

    def set_active_merchant_mode
      ActiveMerchant::Billing::Base.mode = payment_method.mode.to_sym
    end

    def do_authorize(options = {})
      options.symbolize_keys!
      options.assert_valid_keys(:creditcard)

      creditcard = options[:creditcard]

      unless valid_card?(creditcard)
        @errors.push(*creditcard.errors.full_messages)
        return false
      end


      response = gateway.authorize(order.total_amount_in_cents, creditcard, Util.am_options(order))
      record_transaction(response, 'authorized', card_number: creditcard.display_number, cardtype: creditcard.cardtype)

      if response.success?
        order.update_attributes(payment_method: payment_method)
        order.authorize
      else
        @errors << 'Credit card was declined. Please try again!'
        return false
      end
    end

    def do_purchase(options = {})
      options.symbolize_keys!
      options.assert_valid_keys(:creditcard)

      creditcard = options[:creditcard]

      unless valid_card?(creditcard)
        @errors.push(*creditcard.errors.full_messages)
        return false
      end

      response = gateway.purchase(order.total_amount_in_cents, creditcard)
      record_transaction(response, 'purchased', card_number: creditcard.display_number, cardtype: creditcard.cardtype)

      if response.success?
        order.update_attributes(payment_method: payment_method)
        order.purchase
      else
        @errors << 'Credit card was declined. Please try again!'
        return false
      end
    end

    def do_kapture(options = {})
      options.symbolize_keys!
      options.assert_valid_keys(:transaction_gid)
      tsx_id = options[:transaction_gid]

      response = gateway.capture(order.total_amount_in_cents, tsx_id, {})
      record_transaction(response, 'captured')

      if response.success?
        order.kapture
      else
        @errors << "Capture failed"
        false
      end
    end

    def do_void(options = {})
      options.symbolize_keys!
      options.assert_valid_keys(:transaction_gid)
      transaction_gid = options[:transaction_gid]

      response = gateway.void(transaction_gid, {})
      record_transaction(response, 'voided')

      response.success?.tap do |success|
        order.void if success
      end
    end

    def do_refund(options = {})
      options.symbolize_keys!
      options.assert_valid_keys(:transaction_gid, :card_number)

      transaction_gid      = options[:transaction_gid]
      card_number = options[:card_number]

      response = gateway.refund(order.total_amount_in_cents, transaction_gid, card_number: card_number)
      record_transaction(response, 'refunded')

      response.success?.tap do |success|
        order.refund if success
      end

    end

    def record_transaction(response, operation, additional_options = {})
      #
      # Following code invokes response.authorization to get transaction id. Note that this method can be called
      # after capture or refund. And it feels weird to call +authorization+ when the operation was +capture+.
      # However this is how ActiveMerchant works. It sets transaction id in +authorization+ key.
      #
      # https://github.com/Shopify/active_merchant/blob/master/lib/active_merchant/billing/gateways/authorize_net.rb#L283
      #
      transaction_gid = response.authorization

      options = { operation:          operation,
                  params:             response.params,
                  success:            response.success?,
                  metadata:           additional_options,
                  transaction_gid:    transaction_gid }

      if response.success?
        options.update(amount: order.total_amount_in_cents)
      end

      order.payment_transactions.create(options)
    end

    def valid_card?(creditcard)
      creditcard && creditcard.valid?
    end
  end
end
