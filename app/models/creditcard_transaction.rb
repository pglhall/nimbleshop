class CreditcardTransaction < ActiveRecord::Base
  belongs_to :order
  belongs_to :creditcard

  scope :active,      where(active: true)
  scope :inactive,    where(active: false)
  scope :captured,    where(status: 'captured')
  scope :authorized,  where(status: 'authorized')
  scope :purchased,   where(status: 'purchased')

  def authorized?
    self.status == 'authorized'
  end

  def captured?
    self.status == 'captured'
  end

  def purchased?
    self.status == 'purchased'
  end

  def active!
    update_attributes(active: true)
  end

  def inactive!
    update_attributes(active: false)
  end

  def capture(options)
    GatewayProcessor.new(payment_method_permalink: options.fetch(:payment_method_permalink),
                          creditcard: creditcard,
                          amount: amount).capture(self)
  end

  def void(options)
    GatewayProcessor.new(payment_method_permalink: options.fetch(:payment_method_permalink)).void(self)
  end
end
