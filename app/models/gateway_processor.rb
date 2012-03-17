class GatewayProcessor

  attr_reader :amount, :creditcard, :order, :payment_method
  delegate :gateway, to: :payment_method

  def initialize(options = {})
    options.symbolize_keys!
    options.assert_valid_keys(:payment_method_permalink, :amount, :creditcard, :order)

    @payment_method = PaymentMethod.find_by_permalink!(options[:payment_method_permalink])
    @amount         = options[:amount]
    @order          = options[:order]
    @creditcard     = options[:creditcard]
  end

  def purchase
    response  = gateway.purchase(amount, creditcard)
    save_cc_and_create_transaction_record!(response, 'purchased')
  end

  def authorize
    response  = gateway.authorize(amount, creditcard)
    save_cc_and_create_transaction_record!(response, 'authorized')
  end

  def capture(transaction)
    response = gateway.capture(amount, transaction.transaction_gid, {})
    update_transaction_record_and_add_another!(transaction, response, 'captured')
  end

  def void(transaction)
    response = gateway.void(amount, transaction.transaction_gid, {})
    update_transaction_record_and_add_another!(transaction, response, 'voided')
  end

  private

  def update_transaction_record_and_add_another!(transaction, response, status)
    if transaction_gid = extract_transaction_id(response)
      transaction.inactive!

      order.transactions.create!({
        amount:           transaction.amount,
        params:           response.params,
        transaction_gid:  transaction_gid,
        active:           true,
        status:           status,
        creditcard_id:    creditcard.id
      })
    end
  end

  def save_cc_and_create_transaction_record!(response, status)
    if transaction_gid = extract_transaction_id(response)
      creditcard.save!

      order.transactions.create!({
        amount:           order.total_amount,
        params:           response.params,
        transaction_gid:  transaction_gid,
        active:           true,
        status:           status,
        creditcard_id:    creditcard.id
      })
    end
  end

  def extract_transaction_id(response)
    payment_method.extract_transaction_id(response)
  end
end
