class Creditcard < ActiveRecord::Base

  attr_accessor :cvv, :number, :amcard, :month, :year, :address1, :address2, :first_name, :last_name, :state, :zipcode

  before_validation :set_cardtype,                on: :create
  before_validation :strip_non_numeric_values,    on: :create

  validate :validation_by_active_merchant,        on: :create

  before_create :set_masked_number

  alias :verification_value :cvv # ActiveMerchant needs this

  def verification_value?
    true # ActiveMerchant needs this
  end

  def self.build_for_payment_processing(params, order)
    addr = order.final_billing_address
    Creditcard.new(params[:creditcard].merge(address1: addr.address1,
                                             address2: addr.address2,
                                             first_name: addr.first_name,
                                             last_name: addr.last_name,
                                             state: addr.state,
                                             zipcode: addr.zipcode))
  end

  private

  def strip_non_numeric_values
    self.number = self.number.gsub(/[^\d]/, '') if self.number
  end

  def set_cardtype
    self.cardtype = ActiveMerchant::Billing::CreditCard.type?(number)
  end

  def validation_by_active_merchant
    self.month = self.expires_on.strftime('%m').to_i
    self.year = self.expires_on.strftime('%Y').to_i

    self.amcard = ActiveMerchant::Billing::CreditCard.new(
      type:               cardtype,
      number:             number,
      verification_value: verification_value,
      month:              month,
      year:               year,
      first_name:         first_name,
      last_name:          last_name)

    unless self.amcard.valid?
      self.amcard.errors.full_messages.each do |message|
        # TODO make it i18n compatible
        message.gsub!(/Number is required/,'Credit card number is required')
        message.gsub!(/Verification value is required/, 'CVV number is required')
        self.errors.add(:base, message)
      end
    end
  end

  def set_masked_number
    self.masked_number ||= self.amcard.display_number
  end

end
