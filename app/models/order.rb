class Order < ActiveRecord::Base
  include InquirerMethods

  # to allow extensions to keep data
  store :settings

  attr_protected :number
  attr_accessor :validate_email
  inquire_method :shipping_status, :payment_status, :status

  has_many    :shipments
  belongs_to  :shipping_method
  has_many    :line_items
  belongs_to  :user
  has_many    :creditcard_transactions

  belongs_to  :payment_method

  has_one     :shipping_address
  has_one     :billing_address

  accepts_nested_attributes_for :shipping_address, allow_destroy: true
  accepts_nested_attributes_for :billing_address,  reject_if: :billing_disabled?, allow_destroy: true

  delegate :shipping_cost, to: :shipping_method

  validates :email, email: true, if: :validate_email

  # cancelled is when third party service like Splitable sends a webhook stating that order has been cancelled
  validates_inclusion_of :shipping_status, in: %W( nothing_to_ship shipped partially_shipped shipping_pending cancelled )
  validates_inclusion_of :status,          in: %W( open closed )
  validates_inclusion_of :checkout_status, in: %W( items_added_to_cart billing_address_provided shipping_method_provided )

  validates :payment_method, presence: true, if: lambda { |record| record.payment_status != 'abandoned' }

  before_create :set_order_number

  # captured and purchased statues are only for a brief transition. Once a transaction is captured then after_cpatured is called and
  # there after doing a bunch of things the status changes to 'paid'.
  #
  # Similarly status 'paid' is only for a brief transition. Once an order is put in 'purchased' state then after_purchased is called and
  # this method sets the status as 'paid'.
  state_machine :payment_status, :initial => :abandoned do
    after_transition  on: :authorized, do: :after_authorized
    after_transition  on: :purchased,  do: :after_purchased
    after_transition  on: :captured,   do: :after_captured
    before_transition on: :cancelled,  do: :before_cancelled
    before_transition on: :refunded,   do: :before_refunded

    event :authorized do
      transition from: [:abandoned],  to: :authorized
    end

    event :captured do
      transition from: [:authorized],  to: :paid
    end

    event :purchased do
      transition from: [:abandoned],  to: :paid
    end

    event :cancelled do
      transition [:authorized] => :cancelled, if: lambda { |o| o.authorized? }
    end

    event :refunded do
      transition [:paid] => :refunded, if: lambda { |o| o.paid? }
    end


    state :authorized, :captured, :purchased, :paid, :refunded, :cancelled
  end

  def after_authorized
    Mailer.order_notification(self.number).deliver
    AdminMailer.new_order_notification(self.number).deliver
    self.shipping_pending
  end

  def after_captured
    # so that others can overrite
  end

  def after_paid
    # so that others can overrite
  end

  def after_purchased
    Mailer.order_notification(self.number).deliver
    AdminMailer.new_order_notification(self.number).deliver
    self.update_attributes!(shipping_status: 'shipping_pending', splitable_paid_at: Time.zone.now.to_s(:long))
  end

  def before_cancelled
    self.creditcard_transactions.find_all_by_status_and_active('authorized', true).each { |t| t.void }
    self.nothing_to_ship
  end

  def before_refunded
    self.creditcard_transactions.find_all_by_status_and_active('captured', true).each { |t| t.void }
    self.nothing_to_ship
  end


  state_machine :shipping_status, initial: :nothing_to_ship do
    after_transition :on => :shipped, do:  :after_shipped

    event :shipping_pending do
      transition from: [:nothing_to_ship], to: :shipping_pending
    end

    event :shipped do
      transition from: [:shipping_pending], to: :shipped
    end

    event :nothing_to_ship do
      transition from: [:shipping_pending], to: :nothing_to_ship, if: lambda { |o| o.shipping_pending? }
    end

    state :nothing_to_ship, :shippping_pending, :shipped
  end

  def after_shipped
    Mailer.shipping_notification(self.number).deliver
    self.update_attributes!(shipped_at: Time.now)
  end



  def payment_date
    case payment_method
    when PaymentMethod::Splitable
      self.splitable_paid_at
    when PaymentMethod::AuthorizeNet
      self.creditcard_transactions.first.created_at.to_s(:long)
    end
  end

  def masked_creditcard_number
    case payment_method
    when PaymentMethod::Splitable
      nil
    when PaymentMethod::AuthorizeNet
      self.creditcard_transactions.first.creditcard.masked_number
    end
  end

  def available_shipping_methods
    ShippingMethod.available_for(amount, shipping_address)
  end

  def item_count
    self.line_items.count
  end

  alias_method :items, :line_items

  def add(product, variant = nil)
    options = { product_id: product.id }

    options.update(variant_id: variant.id) if variant

    unless line_items.where(options).any?
      line_items.create(options.merge(quantity: 1))
    end
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
    shipping_cost_zero_with_no_choice? ? price : price + shipping_cost.to_s.to_d
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

  def initialize_addresses
    unless shipping_address
      build_shipping_address({
        country_code: "US", use_for_billing:  true
      })
    end

    billing_address || build_billing_address(country_code: "US")
  end

  def billing_disabled?(attributes)
    attributes['use_for_billing'].blank? ||
      attributes['use_for_billing'] == "false"
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
