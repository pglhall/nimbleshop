require "spec_helper"

describe Mailer do

  before do
    ActionMailer::Base.deliveries.clear
  end

  let(:order) { create(:order) }

  describe '#order_notification' do
    it 'should have one creditcard record if fixtures are read properly' do
      skip 'reading data from fixture still not working' do
        Creditcard.count.must_equal 1
      end
    end
  end

end
