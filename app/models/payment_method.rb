class PaymentMethod < ActiveRecord::Base

  include Permalink::Builder

  store :settings

  scope :enabled, where(enabled: true)

  def use_ssl
    settings[:use_ssl]
  end

  def set_mode
    ActiveMerchant::Billing::Base.mode = :test
    if Rails.env.production? && Shop.first.process_credit_card_for_real?
      ActiveMerchant::Billing::Base.mode = :production
    end
  end

  def self.load_default!
    if count > 0
      raise "Only load into empty db"
    end

    settings = ConfigLoader.new('payment.yml').load

    settings.each_pair do | payment_method_name, preferences |
      attributes = {
        name: preferences.delete(:name),
        description: preferences.delete(:description)
      }

      payment_klass = const_get(payment_method_name.to_s.classify)

      instance = payment_klass.new(attributes)

      preferences.each_pair do | attr, value |
        instance.send("#{attr}=", value)
      end

      instance.save
    end
  end


  def self.partialize
    name.gsub("PaymentMethod::","").underscore
  end
end
