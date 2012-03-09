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
  has_many    :transactions, dependent:  :destroy, class_name: "CreditcardTransaction" do
    def primary
      first
    end
  end

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
    after_transition  on: :transaction_authorized, do: :after_authorized
    after_transition  on: :transaction_captured,   do: :after_captured
    after_transition  on: :transaction_purchased,  do: :after_purchased
    before_transition on: :transaction_cancelled,  do: :before_cancelled
    before_transition on: :transaction_refunded,   do: :before_refunded

    event :transaction_authorized do
      transition abandoned: :authorized 
    end

    event :transaction_captured do
      transition authorized: :paid 
    end

    event :transaction_purchased do
      transition abandoned: :paid 
    end

    event :transaction_cancelled do
      transition authorized: :cancelled
    end

    event :transaction_refunded do
      transition paid: :refunded
    end

    state :authorized, :captured, :purchased, :paid, :refunded, :cancelled do
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

  def payment_date
    case payment_method
    when PaymentMethod::Splitable
      splitable_paid_at
    when PaymentMethod::AuthorizeNet
      transactions.primary.created_at.to_s(:long)
    end
  end

  def masked_creditcard_number
    case payment_method
    when PaymentMethod::Splitable
      nil
    when PaymentMethod::AuthorizeNet
      transactions.primary.creditcard.masked_number
    end
  end

  def available_shipping_methods
    ShippingMethod.available_for(price, shipping_address)
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
    return unless line_item = line_item_of(product_id)

    if quantity > 0 
      line_item.update_attributes(quantity: quantity) 
    else
      line_item.destroy
    end
  end

  def remove(product)
    set_quantity(product.id, 0)
  end

  def price
    line_items.map(&:price).reduce(:+) || 0
  end

  def total_amount
    price + shipping_cost + tax
  end

  def to_param
    number
  end

  def final_billing_address
    unless shipping_address.try(:use_for_billing)
      return billing_address
    end

    shipping_address
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

  def line_item_of(product_id)
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
    @_tax_calculator ||= SimpleTaxCalculator.new(self, Shop.first)
  end

  def shipping_cost_calculator
    @_shipping_cost_calculator ||= ShippingCostCalculator.new(self)
  end

  def mark_split_time
    update_attributes!(splitable_paid_at: Time.zone.now.to_s(:long))
  end

  def send_email_notifications
    Mailer.order_notification(number).deliver
    AdminMailer.new_order_notification(number).deliver
  end

  def after_authorized
    send_email_notifications
    shipping_pending
  end

  def after_captured
    # so that others can overrite
  end

  def after_paid
    # so that others can overrite
  end

  def after_purchased
    send_email_notifications
    shipping_pending
    mark_split_time
  end

  def before_cancelled
    transactions.authorized.active.each(&:void)
    cancel_shipment
  end

  def before_refunded
    transactions.captured.active.each(&:void)
    cancel_shipment
  end

  def after_shipped
    Mailer.shipping_notification(number).deliver
    touch(:shipped_at)
  end
end
