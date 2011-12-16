class PaymentMethod::PaypalWebsitePaymentsStandard < PaymentMethod

  attr_accessor :image_on_checkout_page, :merchant_email_address, :return_url, :notify_url, :request_submission_url

  def self.instance
    @gateway ||= begin
      set_mode
      gateway_klass.logger = Rails.logger unless Rails.env.production?
      ::BinaryMerchant::AuthorizeNetGateway.new( gateway_klass.new(credentials) )
    end
  end

  private

  def self.credentials
    { login: self.login_id , password: self.transaction_key }
  end

  def self.gateway_klass
    if Rails.env.test?
      ActiveMerchant::Billing::AuthorizeNetMockedGateway
    else
      ActiveMerchant::Billing::AuthorizeNetGateway
    end
  end

  def set_data
    self.data = { image_on_checkout_page: @image_on_checkout_page,
                  merchant_email_address: @merchant_email_address,
                  return_url: @return_url,
                  notify_url: @notify_url,
                  request_submission_url: @request_submission_url }
  end

end
