class Creditcard < ActiveRecord::Base

  attr_accessor :cvv, 
                :number, 
                :first_name, 
                :last_name, 
                :address1, 
                :address2, 
                :state, 
                :zipcode

  alias :verification_value :cvv # ActiveMerchant needs this

  has_many :transactions, class_name: 'CreditcardTransaction' 
  has_many :orders,       through: :transactions

  before_validation :set_cardtype,              on: :create

  before_validation :strip_non_numeric_values,  on: :create, if: :number

  validate :validation_by_active_merchant,      on: :create

  before_create :set_masked_number

  validates :number,      presence: true, on: :create
  validates :last_name,   presence: true, on: :create
  validates :first_name,  presence: true, on: :create

  def verification_value?
    true # ActiveMerchant needs this
  end

  def month
    expires_on.strftime('%m').to_i
  end

  def year
    expires_on.strftime('%Y').to_i
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
    to_active_merchant_credit_card.tap do | card |
      propogate_active_merchant_errors(card) unless card.valid?
    end
  end

  def to_active_merchant_credit_card
    options = {}
    add_user_data(options)
    add_credit_card_data(options)

    ActiveMerchant::Billing::CreditCard.new(options)
  end

  def propogate_active_merchant_errors(amcard)
    amcard.errors.full_messages.each do |message|
        # TODO make it i18n compatible
        message.gsub!(/Number is required/,'Credit card number is required')
        message.gsub!(/Verification value is required/, 'CVV number is required')
      self.errors.add(:base, message)
    end
  end

  def set_masked_number
    self.masked_number = to_active_merchant_credit_card.display_number
  end
end
