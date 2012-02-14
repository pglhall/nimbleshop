class PaymentMethod < ActiveRecord::Base

  include BuildPermalink

  store :settings

  scope :enabled, where(enabled: true)

  def set_mode
    # FIXME before going live
    #ActiveMerchant::Billing::Base.mode = Rails.env.production? ? :production : :test
    ActiveMerchant::Billing::Base.mode = :test
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

      instance = payment_klass.create!(attributes)

      preferences.each_pair do | preference, value |
        m = "#{payment_method_name}_#{preference}="
        instance.send(m, value)
      end
      instance.save
    end
  end

  private

end
