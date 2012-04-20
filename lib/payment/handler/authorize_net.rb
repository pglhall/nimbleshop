module Payment
  module Handler
    class AuthorizeNet < Base

      delegate :client, to: Payment::Gateway::AuthorizeNet

      private

      def do_authorize(options = {})
        options.symbolize_keys!
        options.assert_valid_keys(:creditcard)

        creditcard = options[:creditcard]

        return false unless valid_card?(creditcard)

        response = client.authorize(order.total_amount_in_cents, creditcard)
        succeded = response.success?

        add_to_order(response, 'authorized')

        if succeded
          order.update_attributes(payment_method: Shop.authorize_net)
          order.transaction_authorized
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

        add_to_order(response, 'purchased')

        if succeded
          order.update_attributes(payment_method: Shop.authorize_net)
          order.transaction_purchased
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
          order.transaction_captured
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
          order.transaction_voided
        end

        succeded
      end

      def do_refund(options = {})
        options.symbolize_keys!
        options.assert_valid_keys(:transaction_gid)
        tsx_id = options[:transaction_gid]

        response = client.refund(order.total_amount_in_cents, tsx_id, {})
        add_to_order(response, 'refunded')

        succeded = response.success?

        if succeded
          order.transaction_refunded
        end

        succeded
      end

      def add_to_order(response, operation)
        options = { success: response.success?,
                    params: response.params,
                    transaction_gid: response.authorization,
                    operation: operation }

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
end
