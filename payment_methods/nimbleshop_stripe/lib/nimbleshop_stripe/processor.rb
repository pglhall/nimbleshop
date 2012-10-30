module NimbleshopStripe
  class Processor < Processor::Base

    attr_reader :order, :payment_method, :errors, :gateway

    def initialize(options)
      @errors = []
      @order = options.fetch(:order)
      @payment_method = options.fetch(:payment_method)
      @gateway = ::NimbleshopStripe::Gateway.instance(payment_method)
      ::Stripe.api_key = payment_method.secret_key
    end

    private

    def set_active_merchant_mode # :nodoc:
      ActiveMerchant::Billing::Base.mode = payment_method.mode.to_sym
    end

    def do_authorize(options = {})
      #Stripe does not support authorize operation
      do_purchase(options)
    end

    # Creates purchase for the order amount.
    #
    # === Options
    #
    # * <tt>:token</tt> -- token to be charged. This is a required field.
    #
    # This method returns false if purchase fails. Error messages are in <tt>errors</tt> array.
    # If purchase succeeds then <tt>order.purchase</tt> is invoked.
    #
    def do_purchase(options = {})
      options.symbolize_keys!
      options.assert_valid_keys(:token)

      token = options[:token]

      response = gateway.purchase(order.total_amount_in_cents, token)

      ::Nimbleshop::PaymentTransactionRecorder.new(payment_transaction_recorder_hash(response, token)).record

      if response.success?
        order.update_attributes(payment_method: payment_method)
        order.purchase!
      else
        Rails.logger.info response.params['error']['message']
        @errors << 'Credit card was declined. Please try again!'
        return false
      end
    end

    def payment_transaction_recorder_hash(response, token)
      token_response = ::Stripe::Token.retrieve(token)

      {  response: response,
         operation: :purchased,
         transaction_gid: token_response.id,
         metadata: {  fingerprint: token_response.card.fingerprint,
                      livemode: token_response.livemode,
                      card_number: "XXXX-XXXX-XXXX-#{token_response.card.last4}",
                      cardtype: token_response.card.type.downcase }}
    end

    # Voids the previously authorized transaction.
    #
    # === Options
    #
    # * <tt>:transaction_gid</tt> -- transaction_gid is the transaction id returned by the gateway. This is a required field.
    #
    # This method returns false if void fails. Error messages are in <tt>errors</tt> array.
    # If void succeeds then <tt>order.void</tt> is invoked.
    #
    def do_void(options = {})
      options.symbolize_keys!
      options.assert_valid_keys(:transaction_gid)
      transaction_gid = options[:transaction_gid]

      response = gateway.void(transaction_gid, {})
      ::Nimbleshop::PaymentTransactionRecorder.new(response: response, operation: :voided, order: order).record

      if response.success?
        order.void
      else
        @errors << "Void operation failed"
        false
      end
    end

    # Refunds the given transaction.
    #
    # === Options
    #
    # * <tt>:transaction_gid</tt> -- transaction_gid is the transaction id returned by the gateway. This is a required field.
    #
    # This method returns false if refund fails. Error messages are in <tt>errors</tt> array.
    # If refund succeeds then <tt>order.refund</tt> is invoked.
    #
    def do_refund(options = {})
      options.symbolize_keys!
      options.assert_valid_keys(:transaction_gid, :card_number)

      transaction_gid      = options[:transaction_gid]
      card_number = options[:card_number]

      response = gateway.refund(order.total_amount_in_cents, transaction_gid, card_number: card_number)
      ::Nimbleshop::PaymentTransactionRecorder.new(response: response, operation: :refunded, order: order).record

      if response.success?
        order.refund
      else
        @errors << "Refund failed"
        false
      end

    end

  end
end
