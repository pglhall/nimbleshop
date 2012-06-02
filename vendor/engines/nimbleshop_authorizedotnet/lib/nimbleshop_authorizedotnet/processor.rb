module NimbleshopAuthorizedotnet
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

      response = gateway.authorize(order.total_amount_in_cents, creditcard)
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

    def do_capture(options = {})
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

    # TODO How to ensure that the database operation after the transaction with Authorize.net
    # is indeed done
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
      options = { operation:          operation,
                  params:             response.params,
                  success:            response.success?,
                  metadata:           additional_options,
                  transaction_gid:    response.authorization } # TODO is the transaction_gid  response.authorization. will it be
                                                               # response.capture in case of capture

      if response.success? # How about recording amount in failure case too. success key keeps track of which one was success and which one is failure
        options.update(amount: order.total_amount_in_cents)
      end

      order.payment_transactions.create(options)
    end

    def valid_card?(creditcard)
      creditcard && creditcard.valid?
    end
  end
end
