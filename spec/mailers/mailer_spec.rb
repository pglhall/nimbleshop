require "spec_helper"

describe Mailer do

  before do
    ActionMailer::Base.deliveries.clear
  end

  let(:order) { create(:order) }

  describe '#order_notification' do
    it { Mailer.order_notification(order.number).should render_email }
  end

end
