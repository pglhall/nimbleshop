class GatewayProcessor

  attr_reader :gateway, :amount, :creditcard, :order

  def initialize(options = {})
    payment_method = PaymentMethod.find_by_permalink!(options.fetch(:payment_method_permalink))
    @gateway    =  payment_method.gateway
    @amount     = options[:amount]
    @creditcard = options[:creditcard] # not needed for capture case
    @order      = options[:order]
  end

  def purchase
    response = gateway.purchase(amount, creditcard)
    gateway.get_transaction_id_for_purchase(response).tap do |transaction_gid|
      save_cc_and_create_transaction_record!(transaction_gid, response, 'purchased')
    end
  end

  def authorize
    response = gateway.authorize(amount, creditcard)
    gateway.get_transaction_id_for_authorize(response).tap do |transaction_gid|
      save_cc_and_create_transaction_record!(transaction_gid, response, 'authorized')
    end
  end

  def capture(transaction)
    response = gateway.capture(amount, transaction.transaction_gid, {})
    gateway.get_transaction_id_for_capture(response).tap do |transaction_gid|
      update_transaction_record_and_add_another!(transaction, transaction_gid, response, 'captured')
    end
  end

  def void(transaction)
    response = gateway.void(amount, transaction.transaction_gid, {})
    gateway.get_transaction_id_for_void(response).tap do |transaction_gid|
      update_transaction_record_and_add_another!(transaction, transaction_gid, response, 'voided')
    end
  end

  private

  def update_transaction_record_and_add_another!(transaction, transaction_gid, response, status)
    transaction.update_attributes!(active: false)
    CreditcardTransaction.create!(transaction_gid: transaction_gid,
                        params: response.params,
                        amount: transaction.amount,
                        creditcard_id: transaction.creditcard_id,
                        active: true,
                        status: status,
                        order_id: transaction.order_id,
                        parent_id: transaction.id)
  end

  def save_cc_and_create_transaction_record!(transaction_gid, response, status)
    creditcard.save!
    CreditcardTransaction.create!(transaction_gid: transaction_gid,
                        params: response.params,
                        amount: order.total_amount,
                        creditcard_id: creditcard.id,
                        active: true,
                        status: status,
                        order_id: order.id)
  end

end
