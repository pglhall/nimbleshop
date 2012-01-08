# TODO why is this needed
Address

class Order < ActiveRecord::Base

  attr_protected :number
  attr_accessor :validate_email

  has_many    :shipments
  belongs_to  :shipping_method
  has_many    :line_items
  has_many    :products, :through => :line_items
  belongs_to  :user
  has_many    :creditcard_transactions

  belongs_to  :payment_method

  has_one     :shipping_address
  has_one     :billing_address
  accepts_nested_attributes_for :shipping_address, :billing_address, allow_destroy: true

  validates :email, :email => true, :if => lambda {|record| record.validate_email }

  validates_inclusion_of :payment_status,  :in => %W( abandoned_early abandoned_late authorized paid refunded voided )
  validates_inclusion_of :shipping_status, :in => %W( nothing_to_ship shipped partially_shipped shipping_pending )
  validates_inclusion_of :status,          :in => %W( open closed )

  before_create :set_order_number
  before_save   :change_shipping_status
  after_save    :send_order_confirmation_email

  def available_shipping_methods
    ShippingMethod.order('shipping_price asc').all.select { |e| e.available_for(self) }
  end

  def item_count
    self.line_items.count
  end

  def items
    line_items
  end

  def add(product)
    return if self.products.include?(product)
    self.line_items.create!(:product => product, :quantity => 1)
  end

  def set_quantity(product, quantity)
    return unless self.products.include?(product)
    if quantity <= 0
      line_item_of(product).destroy
    else
      line_item_of(product).update_attributes(:quantity => quantity)
    end
  end

  def remove(product)
    return unless self.products.include?(product)
    line_item_of(product).destroy
  end

  def price
    self.line_items.inject(0) { |sum, item| sum += item.line_price }
  end
  alias :amount :price

  def price_with_shipping
    shipping_cost_zero_with_no_choice? ? price : price + shipping_method.shipping_cost
  end
  alias :total_amount :price_with_shipping
  alias :total_price :price_with_shipping
  alias :grand_total :price_with_shipping


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

  private

  def line_item_of(product)
    self.line_items.find_by_product_id(product.id)
  end

  def set_order_number
    self.number = Random.new.rand(11111111...99999999).to_s
  end

  def send_order_confirmation_email
    if self.payment_status_changed? && payment_status == 'authorized'
      Mailer.order_confirmation(self.number).deliver
      AdminMailer.new_order_notification(self.number).deliver
    end
  end

  def change_shipping_status
    if self.payment_status_changed? && payment_status == 'authorized' && self.shipping_status == 'nothing_to_ship'
      self.shipping_status = 'shipping_pending'
    end
  end

end
