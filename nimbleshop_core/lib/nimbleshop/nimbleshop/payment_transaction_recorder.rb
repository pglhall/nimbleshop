module Nimbleshop

  # This class is responsible for recording the payment transaction.
  #
  # Note that even the unsuccessful transactions are recorded for
  # reporting and analysis purpose.
  #
  class PaymentTransactionRecorder

    def initialize(options = {})
      options.symbolize_keys!
      options.assert_valid_keys :order, :response, :operation, :transaction_gid, :metadata, :params
      options.reverse_merge! metadata: {}

      @options = options
    end

    def record
      order     = @options[:order]
      response  = @options[:response]

      h = { operation: @options[:operation].to_s,
            params: response.params,
            success: response.success? ,
            amount: order.total_amount_in_cents,
            metadata: @options[:metadata],
            transaction_gid: @options[:transaction_gid] }

      order.payment_transactions.create!(h)

    end
  end
end
