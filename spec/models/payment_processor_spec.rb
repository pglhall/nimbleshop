require 'spec_helper'

describe PaymentProcessor do

  def playcasette(casette)
    VCR.use_cassette(casette)  { yield }
  end

  let(:order)       { create(:order)      }
  let(:processor) { PaymentProcessor.new(creditcard, order) }


  describe '#authorize' do
    before { Shop.first.update_attribute(:default_creditcard_action, 'authorize') }
    describe "when credit card is invalid" do
      let(:creditcard)  { build(:creditcard, number: 2)  }
      before do
        playcasette('authorize.net/authorize-failure') { processor.process }
      end
      it { creditcard.errors[:base].must_equal ['Credit card was declined. Please try again! '] }
    end

    describe "when credit card is valid" do
      let(:creditcard)  { build(:creditcard)  }
      before do
        playcasette('authorize.net/authorize-success') { processor.process }
        order.reload
      end
      it  {
        order.must_be(:authorized?)
        order.transactions.count.must_equal 1
        order.transactions.last.must_be(:active?)
        order.transactions.last.must_be(:authorized?)
        order.payment_method.must_equal PaymentMethod.find_by_permalink('authorize-net')
      }
    end
  end

  describe '#purchase' do

    before { Shop.first.update_attribute(:default_creditcard_action, 'purchase') }
    describe "when credit card is valid" do
      let(:creditcard)  { build(:creditcard)  }
      before do
        playcasette('authorize.net/purchase-success') { processor.process }
      end

      it { 
        order.must_be(:paid?)
        order.transactions.count.must_equal 1
        order.transactions.last.must_be(:active?)
        order.transactions.last.must_be(:purchased?)
        order.payment_method.must_equal PaymentMethod.find_by_permalink('authorize-net')
      }
    end

    describe "when credit card is invalid" do
      let(:creditcard)  { build(:creditcard, number: 2)  }
      before do
        playcasette('authorize.net/purchase-failure') { processor.process }
      end

      it { creditcard.errors[:base].must_equal ['Credit card was declined. Please try again! '] }
    end
  end
end
