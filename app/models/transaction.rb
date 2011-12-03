class Transaction < ActiveRecord::Base

  alias_attribute :amount, :price

  def capture(_amount = nil)
    _amount ||= self.amount
    GatewayProcessor.new.capture(_amount, self)
  end

end
