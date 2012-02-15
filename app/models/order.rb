class Order < ActiveRecord::Base

  # to allow extensions to keep data
  store :settings

  attr_protected :number
  attr_accessor :validate_email

  has_many    :shipments
  belongs_to  :shipping_method
  has_many    :line_items
  belongs_to  :user
  has_many    :creditcard_transactions

  belongs_to  :payment_method

  has_one     :shipping_address
  has_one     :billing_address
  accepts_nested_attributes_for :shipping_address, :billing_address, allow_destroy: true

  validates :email, email: true, if: lambda {|record| record.validate_email }

  # cancelled is when third party service like Splitable sends  a webhook stating that order
  # has been cancelled
  validates_inclusion_of :payment_status,  in: %W( abandoned authorized paid refunded voided cancelled)
  validates_inclusion_of :shipping_status, in: %W( nothing_to_ship shipped partially_shipped shipping_pending )
  validates_inclusion_of :status,          in: %W( open closed )
  validates_inclusion_of :checkout_status, in: %W( items_added_to_cart billing_address_provided shipping_method_provided)

  before_create :set_order_number

  state_machine :payment_status, :initial => :abandoned do
    after_transition on: :authorized, do: :after_authorized
    after_transition on: :purchased,  do: :after_purchased
    event :authorized do
      transition from: [:abandoned],  to: :authorized
    end
    event :captured do
      transition from: [:authorized],  to: :paid
    end
    event :purchased do
      transition from: [:abandoned],  to: :paid
    end
  end

  state_machine :shipping_status, initial:  :nothing_to_ship do
    after_transition :on => :shipped, do:  :after_shipped
    event :shipping_pending do
      transition from: [:nothing_to_ship], to: :shipping_pending
    end
    event :shipped do
      transition from: [:shipping_pending], to: :shipped
    end
  end

  def after_authorized
    Mailer.order_notification(self.number).deliver
    AdminMailer.new_order_notification(self.number).deliver
    self.shipping_pending
  end

  def after_shipped
    Mailer.shipping_notification(self.number).deliver
    self.update_attributes!(shipped_at: Time.now)
    if self.payment_status.authorized?
      transaction = self.creditcard_transactions.first
      if GatewayProcessor.new(payment_method_permalink: 'authorize-net', amount: self.total_amount).capture(transaction)
        self.captured
      end
    end
  end

  def after_purchased
    Mailer.order_notification(self.number).deliver
    AdminMailer.new_order_notification(self.number).deliver
    self.shipping_pending
  end

  def available_shipping_methods
    ShippingMethod.available_for(amount, shipping_address)
    #ShippingMethod.order('base_price asc').all.select { |e| e.available_for(order.amount, order.shipping_address) }
  end

  def item_count
    self.line_items.count
  end

  alias_method :items, :line_items

  def add(product, variant = nil)
    if variant
      return if self.line_items.find_by_product_id_and_variant_id(product.id, variant.id)
    else
      return if self.line_items.find_by_product_id(product.id)
    end
    self.line_items.create!(product: product, quantity: 1, variant: variant)
  end

  def set_quantity(product_id, quantity)
    return unless self.line_items.find_by_product_id(product_id)

    line_item = line_item_of(product_id)
    (quantity > 0) ? line_item.update_attributes(quantity: quantity) : line_item.destroy
  end

  def remove(product)
    line_item_of(product).destroy if self.products.include?(product)
  end

  def price
    self.line_items.inject(0) { |sum, item| sum += item.price }
  end
  alias_method :amount, :price

  def price_with_shipping
    shipping_cost_zero_with_no_choice? ? price : price + shipping_method.shipping_cost.to_s.to_d
  end
  alias_method :total_amount, :price_with_shipping
  alias_method :total_price,  :price_with_shipping
  alias_method :grand_total,  :price_with_shipping


  # This methods returns true if the shipping cost is zero and usre has no choice. This
  # case could arise
  # * if shop has not configured shipping cost
  # * if shop has configured shipping cost . However for this order the shipping cost is zero
  #   and no other shipping rule applies. So user must select the only option available
  def shipping_cost_zero_with_no_choice?
    shipping_method.blank? || (shipping_method.shipping_cost == 0)
  end

  def to_param
    self.number
  end

  def final_billing_address
    return nil if shipping_address.blank?
    shipping_address.use_for_billing ? shipping_address : billing_address
  end

  def shipping_status
    ActiveSupport::StringInquirer.new(self['shipping_status'])
  end

  def payment_status
    ActiveSupport::StringInquirer.new(self['payment_status'])
  end

  def status
    ActiveSupport::StringInquirer.new(self['status'])
  end

  private

  def line_item_of(product_id)
    self.line_items.find_by_product_id(product_id)
  end

  def set_order_number
    _number = Random.new.rand(11111111...99999999).to_s
    while self.class.exists?(number: _number) do
      _number = Random.new.rand(11111111...99999999).to_s
    end
    self.number = _number
  end

end
