module NimbleshopAuthorizedotnet
  class Billing < Billing::Base

    attr_reader :order

    def client
      NimbleshopAuthorizedotnet::Client.instance
    end

    def initialize(order)
      @order = order
    end

    private

    def do_authorize(options = {})
      options.symbolize_keys!
      options.assert_valid_keys(:creditcard)

      creditcard = options[:creditcard]

      return false unless valid_card?(creditcard)

      response = client.authorize(order.total_amount_in_cents, creditcard)
      succeded = response.success?

      add_to_order(response, 'authorized', card_number: creditcard.display_number)

      if succeded
        order.update_attributes(payment_method: Shop.authorize_net)
        order.authorize
      end

      succeded
    end

    def do_purchase(options = {})
      options.symbolize_keys!
      options.assert_valid_keys(:creditcard)

      creditcard = options[:creditcard]

      return false unless valid_card?(creditcard)

      response = client.purchase(order.total_amount_in_cents, creditcard)
      succeded = response.success?

      add_to_order(response, 'purchased', card_number: creditcard.display_number)

      if succeded
        order.update_attributes(payment_method: Shop.authorize_net)
        order.purchase
      end

      succeded
    end

    def do_capture(options = {})
      options.symbolize_keys!
      options.assert_valid_keys(:transaction_gid)
      tsx_id = options[:transaction_gid]

      response = client.capture(order.total_amount_in_cents, tsx_id, {})
      add_to_order(response, 'captured')

      succeded = response.success?

      if succeded
        order.kapture
      end

      succeded
    end

    def do_void(options = {})
      options.symbolize_keys!
      options.assert_valid_keys(:transaction_gid)
      tsx_id = options[:transaction_gid]

      response = client.void(tsx_id, {})
      add_to_order(response, 'voided')

      succeded = response.success?

      if succeded
        order.void
      end

      succeded
    end

    def do_refund(options = {})
      options.symbolize_keys!
      options.assert_valid_keys(:transaction_gid, :card_number)
      tsx_id      = options[:transaction_gid]
      card_number = options[:card_number]

      response = client.refund(order.total_amount_in_cents, tsx_id, card_number: card_number)
      add_to_order(response, 'refunded')

      succeded = response.success?

      if succeded
        order.refund
      end

      succeded
    end

    def add_to_order(response, operation, additional_options = {})
      options = { operation:          operation,
                  params:             response.params,
                  success:            response.success?,
                  additional_info:    additional_options,
                  transaction_gid:    response.authorization }

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
