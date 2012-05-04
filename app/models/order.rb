class Order < ActiveRecord::Base

  # to allow extensions to keep data
  store :settings

  attr_accessor   :validate_email
  attr_protected  :number

  belongs_to  :user
  belongs_to  :payment_method
  belongs_to  :shipping_method

  has_one     :shipping_address,  dependent:  :destroy
  has_one     :billing_address,   dependent:  :destroy

  has_many    :shipments
  has_many    :line_items,   dependent:  :destroy
  has_many    :products,     through:    :line_items
  has_many    :payment_transactions, dependent:  :destroy

  accepts_nested_attributes_for :shipping_address, allow_destroy: true
  accepts_nested_attributes_for :billing_address,  reject_if: :billing_disabled?, allow_destroy: true

  delegate :tax,            to: :tax_calculator
  delegate :shipping_cost,  to: :shipping_cost_calculator

  validates :email, email: true, if: :validate_email

  # cancelled is when third party service like Splitable sends a webhook stating that order has been cancelled
  validates_inclusion_of :shipping_status, in: %W( nothing_to_ship shipped partially_shipped shipping_pending cancelled )
  validates_inclusion_of :status,          in: %W( open closed )
  validates_inclusion_of :checkout_status, in: %W( items_added_to_cart billing_address_provided shipping_method_provided )


  before_create :set_order_number

  # captured and purchased statues are only for a brief transition. Once a transaction is captured then after_cpatured is called and
  # there after doing a bunch of things the status changes to 'paid'.
  #
  # Similarly status 'paid' is only for a brief transition. Once an order is put in 'purchased' state then after_purchased is called and
  # this method sets the status as 'paid'.
  state_machine :payment_status, initial: :abandoned do
    event(:authorize) { transition abandoned:   :authorized }
    event(:kapture )  { transition authorized:  :paid       }  # capture is a method defined on kernel
    event(:purchase)  { transition abandoned:   :paid       }
    event(:void)      { transition authorized:  :cancelled  }
    event(:refund)    { transition paid:        :refunded   }

    state all - [ :abandoned ] do
      validates :payment_method, presence: true
    end
  end

  state_machine :shipping_status, initial: :nothing_to_ship do
    after_transition :on => :shipped, do:  :after_shipped

    event :shipping_pending do
      transition nothing_to_ship: :shipping_pending
    end

    event :shipped do
      transition shipping_pending: :shipped
    end

    event :cancel_shipment do
      transition shipping_pending: :nothing_to_ship
    end
  end

  def mark_as_paid!
    unless paid_at
      touch(:paid_at)
    end
  end

  def available_shipping_methods
    ShippingMethod.available_for(line_items_total, shipping_address)
  end

  def item_count
    line_items.count
  end

  def add(product, variant = nil)
    options = { product_id: product.id }

    options.update(variant_id: variant.id) if variant

    unless line_items.where(options).any?
      line_items.create(options.merge(quantity: 1))
    end
  end

  def set_quantity(product_id, quantity)
    return unless line_item = line_item_for(product_id)

    if quantity > 0
      line_item.update_attributes(quantity: quantity)
    else
      line_item.destroy
    end
  end

  def remove(product)
    set_quantity(product.id, 0)
  end

  def line_items_total
    line_items.map(&:price).reduce(:+) || 0
  end

  def price
    raise 'use method line_items_total'
  end

  def total_amount
    line_items_total + shipping_cost + tax
  end

  def total_amount_in_cents
    total_amount.to_f.round(2) * 100
  end

  def to_param
    number
  end

  def final_billing_address
    (shipping_address && !shipping_address.use_for_billing) ? billing_address : shipping_address
  end

  def initialize_addresses
    unless shipping_address
      build_shipping_address(country_code: "US", use_for_billing: true)
    end

    billing_address || build_billing_address(country_code: "US")
  end

  def billing_disabled?(attributes)
    attributes['use_for_billing'].blank? ||
      attributes['use_for_billing'] == "false"
  end

  def line_item_for(product_id)
    line_items.find_by_product_id(product_id)
  end

  private

    def set_order_number
      _number = Random.new.rand(11111111...99999999).to_s
      while self.class.exists?(number: _number) do
        _number = Random.new.rand(11111111...99999999).to_s
      end

      self.number = _number
    end

    def tax_calculator
      @_tax_calculator ||= SimpleTaxCalculator.new(self)
    end

    def shipping_cost_calculator
      @_shipping_cost_calculator ||= ShippingCostCalculator.new(self)
    end

    def after_shipped
      Mailer.shipping_notification(number).deliver
      touch(:shipped_at)
    end
end
