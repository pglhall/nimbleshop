module SplitableExtension
  class Client
    include ActiveMerchant::PostsData

    def self.instance
      new(Shop.splitable)
    end

    class_attribute :live_url, :test_url
    self.live_url = 'https://www.splitable.com/api/splits'
    self.test_url = 'https://www.splitable-draft.com/api/splits'

    def initialize(splitable)
      @api_key        = splitable.api_key
      @expires_in     = splitable.expires_in
    end

    def api_notify_url(request)
      'http://' + request.host_with_port + 'admin/payment_methods/splitable_extension/splitable/notify'
    end


    def create(order, request)
      params = build_params(order, request)

      params[:api_key]        = api_key
      params[:api_notify_url] = api_notify_url(request)
      params[:expires_in]     = @expires_in

      url     = test? ? self.test_url : self.live_url
      params  = params.collect { |key, value| "#{key}=#{CGI.escape(value.to_s)}" }.join("&")

      ssl_post(url, params)
    end

    def build_params(order, request)
      params = {}
      add_order_data(params, order)
      add_product_data(params, order.line_items, request)
      params
    end

    def add_order_data(params, order)
      params[:total_amount] = order.total_amount_in_cents
      params[:invoice]      = order.number
      params[:shipping]     = (order.shipping_method.shipping_cost.round(2).to_f * 100).to_i
      params[:tax]          = (order.tax.round(2).to_f * 100).to_i
      params[:description]  = 'See Splitable integrates nicely with nimbleShop'
    end

    def add_product_data(params, products, request)
      products.each.with_index(1) do | item, index |
        params.update(to_param(item, index, request))
      end
    end

    def product_url(item, request)
      request.protocol + request.host_with_port + "/products/#{item.product_permalink}"
    end

    def to_param(item, index, request)
      {
        "amount_#{index}"     => (item.price * 100).to_i,
        "item_name_#{index}"  => item.product_name,
        "quantity_#{index}"   => item.quantity,
        "url_#{index}"        => product_url(item, request)
      }
    end

    def api_key
      test? ? '92746e4d66cb8993' : @api_key
    end

    def test?
      ActiveMerchant::Billing::Base.mode == :test
    end
  end
end
