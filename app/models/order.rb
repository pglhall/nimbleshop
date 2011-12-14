Address

class Order < ActiveRecord::Base

  attr_protected :order_number
  attr_accessor :validate_email

  belongs_to  :shipping_method
  has_many :line_items
  has_many :products, :through => :line_items
  belongs_to :user

  has_one :shipping_address
  has_one :billing_address
  accepts_nested_attributes_for :shipping_address, :billing_address, allow_destroy: true

  validates :email, :email => true, :if => lambda {|record| record.validate_email }

  validates_inclusion_of :status, :in => %W( added_to_cart billing_info_provided authorized paid)

  before_save :set_order_number, :set_status

  def available_shipping_methods
    ShippingMethod.order('shipping_price asc').all.select { |e| e.available_for(self) }
  end

  def paypal_url
    values = {
      :business => Settings.paypal_merchant_email_address,
      :cmd => '_cart',
      :upload => 1,
      :return => Settings.paypal_return_url,
      :invoice => self.number,
      :secret  => 'xxxxxxx',
      :notify_url => Settings.paypal_notify_url
    }
    line_items.each_with_index do |item, index|
      values.merge!({
        "amount_#{index+1}" => item.product.price,
        "item_name_#{index+1}" => item.product.name,
        "item_number_#{index+1}" => item.id,
        "quantity_#{index+1}" => item.quantity
      })
    end
    Settings.paypal_request_submission_url + values.to_query
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
  alias :total_price :price
  alias :amount :price

  def price_with_shipping
    shipping_cost_zero_with_no_choice? ? price : price + shipping_method.shipping_cost
  end


  # This methods returns true if the shipping cost is zero and usre has no choice. This
  # case could arise
  # * if shop has not configured shipping cost
  # * if shop has configured shipping cost . However for this order the shipping cost is zero
  #   and no other shipping rule applies. So user must select the only option available
  def shipping_cost_zero_with_no_choice?
    shipping_method.blank? || (shipping_method.shipping_cost == 0)
  end

  private

  def line_item_of(product)
    self.line_items.find_by_product_id(product.id)
  end

  def set_order_number
    self.number = Random.new.rand(11111111...99999999).to_s
  end

  def set_status
    if self.status == 'added_to_cart' && self.email_changed?
      self.status = 'billing_info_provided'
    end
  end

end
