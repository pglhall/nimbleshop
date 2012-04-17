class GatewayProcessor

  attr_reader :creditcard, :order, :payment_method
  delegate :gateway, to: :payment_method

  def initialize(options = {})
    options.symbolize_keys!
    options.assert_valid_keys(:payment_method, :creditcard, :order)

    @payment_method = options[:payment_method]
    @order          = options[:order]
    @creditcard     = options[:creditcard]
  end

  def purchase
    response  = gateway.purchase(order.total_amount_in_cents, creditcard)
    save_cc_and_create_transaction_record!(response, 'purchased')
  end

  def authorize
    response  = gateway.authorize(order.total_amount_in_cents, creditcard)
    save_cc_and_create_transaction_record!(response, 'authorized')
  end

  def capture(transaction)
    response = gateway.capture(order.total_amount_in_cents, transaction.transaction_gid, {})
    update_transaction_record_and_add_another!(transaction, response, 'captured')
  end

  def void(transaction)
    response = gateway.void(transaction.transaction_gid, {})
    update_transaction_record_and_add_another!(transaction, response, 'voided')
  end

  private

  def update_transaction_record_and_add_another!(transaction, response, status)
    if transaction_gid = extract_transaction_id(response)
      transaction.inactive!

      options = {
        transaction_gid:  transaction_gid,
        amount:           transaction.amount,
        params:           response.params,
        status:           status
      }

      add_transaction(options)
    end
  end

  def save_cc_and_create_transaction_record!(response, status)
    if transaction_gid = extract_transaction_id(response)
      creditcard.save

      options = {
        transaction_gid:  transaction_gid,
        amount:           order.total_amount,
        params:           response.params,
        status:           status
      }

      add_transaction(options)
    end
  end

  def extract_transaction_id(response)
    payment_method.extract_transaction_id(response)
  end

  def add_transaction(options = {})
    order.transactions.create(options.merge(active: true, creditcard: creditcard))
  end
end
