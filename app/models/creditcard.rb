class Creditcard
  extend  ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend  ActiveModel::Callbacks
  include ActiveModel::Validations::Callbacks

  attr_accessor :cvv,
                :number,
                :first_name,
                :last_name,
                :address1,
                :address2,
                :cardtype,
                :month,
                :year,
                :state,
                :zipcode

  alias :verification_value :cvv # ActiveMerchant needs this

  delegate :display_number, to: :to_active_merchant_creditcard

  before_validation :set_cardtype

  before_validation :strip_non_numeric_values, if: :number

  validates_presence_of :last_name, :first_name

  validates_presence_of :number,  message: "^Credit card number is blank"
  validates_presence_of :cvv,     message: "^CVV number is blank"

  validate  :validation_by_active_merchant, if: proc { |r| r.errors.empty? }

  def initialize(attrs = {})
    attrs.each do | name, value |
      send("#{name}=", value)
    end
  end

  def verification_value?
    true # ActiveMerchant needs this
  end

  def persisted?
    false
  end

  private

  def add_user_data(options = {})
    options[:first_name]  = first_name
    options[:last_name]   = last_name
  end

  def add_credit_card_data(options = {})
    options[:year]    = year
    options[:month]   = month
    options[:number]  = number
    options[:type]    = cardtype
    options[:verification_value]  = verification_value
  end

  def strip_non_numeric_values
    self.number = number.to_s.gsub(/[^\d]/, '')
  end

  def set_cardtype
    self.cardtype = ActiveMerchant::Billing::CreditCard.type?(number)
  end

  def validation_by_active_merchant
    amcard = to_active_merchant_creditcard

    unless amcard.valid?
      amcard.errors.full_messages.each do |message|
        errors.add(:base, message)
      end
    end

    amcard.errors.any?
  end

  def to_active_merchant_creditcard
    options = {}
    add_user_data(options)
    add_credit_card_data(options)

    ActiveMerchant::Billing::CreditCard.new(options)
  end
end
