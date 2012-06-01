module NimbleshopSplitable
  class Billing < ::Billing::Base

    attr_reader :errors, :order, :payment_method

    def client
      Client.new(NimbleshopSplitable::Splitable.first)
    end

    def initialize(options = {})

      unless @order = options[:order]
        invoice = options[:invoice].try(:to_s)
        @order   = Order.find_by_number(invoice)
      end

      @errors = []
      @payment_method = NimbleshopSplitable::Splitable.first
    end

    def create_split(options = {})
      options.symbolize_keys!
      options.assert_valid_keys(:request)

      response = client.create(order, options[:request])
      json = ActiveSupport::JSON.decode(response)
      json.values_at('error','split_url')
    end

    def acknowledge(params = {})
      if valid?(params)
        send(resolve_payment_kind(params[:payment_status]), params)
      else
        false
      end
    end

    private

    def resolve_payment_kind(payment_status)
      payment_status == 'paid' ? 'purchase' : 'void'
    end

    def valid?(params)
      @errors.clear
      validate_order
      validate_params(params)
      @errors.empty?
    end

    def validate_order
      unless order
        @errors << "Unknown invoice number"
      end
    end

    def validate_params(params = {})

      unless params[:transaction_id]
        @errors << "transaction_id is blank"
      end

      unless params[:payment_status]
        @errors << "Parameter payment_status is blank"
      end
    end

    def do_purchase(options = {})
      add_to_order(options, 'purchased')
      order.update_attributes(payment_method: payment_method)
      order.purchase

      true
    end

    def do_void(options = {})
      add_to_order(options, 'voided')
      order.update_attributes(payment_method: payment_method)
      order.void

      true
    end

    def add_to_order(params, operation)
      order.payment_transactions.create(operation: operation,
                                        success: true,
                                        transaction_gid: params[:transaction_id],
                                        params: params)
    end
  end
end
