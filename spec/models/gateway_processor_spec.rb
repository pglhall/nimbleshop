require 'spec_helper'

describe GatewayProcessor do

  def playcasette(casette)
    transaction = nil

    VCR.use_cassette(casette) do
      transaction = yield
    end

    transaction
  end

  let(:order)         { create(:order).tap { |t| t.stubs(:total_amount => 100) }  }
  let(:authorize_net) { PaymentMethod.find_by_permalink('authorize-net')          }

  let(:gateway) do
    GatewayProcessor.new({
      order:          order, 
      creditcard:     creditcard,
      payment_method: authorize_net
    })
  end

  describe '#authorize' do
    describe "when credit card is invalid" do
      let(:creditcard)  { build(:creditcard, number: 2)  }
      before do
        @transaction = playcasette('authorize.net/authorize-failure') { gateway.authorize }
      end
      it  { @transaction.must_be(:nil?) }
    end

    describe "when credit card is invalid" do
      let(:creditcard)  { build(:creditcard)  }
      before do
        @transaction = playcasette('authorize.net/authorize-success') { gateway.authorize }
      end
      it  {
        @transaction.must_be(:active?)
        @transaction.must_be(:authorized?)

        @transaction.order_id.must_equal        order.id
        @transaction.creditcard_id.must_equal   creditcard.id
        @transaction.transaction_gid.must_equal '2169881780'
        @transaction.amount.must_equal          100
      }
    end
  end

  describe '#purchase' do
    describe "when credit card is valid" do
      let(:creditcard)  { build(:creditcard)  }
      before do
        @transaction = playcasette('authorize.net/purchase-success') { gateway.purchase }
      end

      it {
        @transaction.must_be(:purchased?)
        @transaction.must_be(:active?)

        @transaction.order_id.must_equal        order.id
        @transaction.creditcard_id.must_equal   creditcard.id
        @transaction.transaction_gid.must_equal '2169919631'
        @transaction.amount.must_equal          100
      }
    end

    describe "when credit card is invalid" do
      let(:creditcard)  { build(:creditcard, number: 2)  }
      before do
        @transaction = playcasette('authorize.net/purchase-failure') { gateway.purchase }
      end
      it { @transaction.must_be(:nil?) }
    end
  end

  describe '#capture' do
    describe "when credit card is valid" do
      let(:creditcard)  { build(:creditcard)  }
      before do
        @authorized = playcasette('authorize.net/authorize-success')  { gateway.authorize }
        @captured   = playcasette('authorize.net/capture-success')    { gateway.capture(@authorized) }
      end

      it 'should have right values' do
        @authorized.reload.wont_be(:active?)

        @captured.must_be(:captured?)
        @captured.must_be(:active?)
        @captured.amount.must_equal 100
        @captured.transaction_gid.must_equal '2169881780'
      end
    end

    describe "when credit card is invalid" do
      let(:creditcard)  { build(:creditcard)  }

      before do
        @authorized = playcasette('authorize.net/authorize-success')  { gateway.authorize }
        creditcard.number = 2
        @captured   = playcasette('authorize.net/capture-failure')    { gateway.capture(@authorized) }
      end

      it 'should have right values' do
        @captured.must_be(:nil?)
      end
    end
  end
  describe '#void' do
    describe "when credit card is valid" do
      let(:creditcard)  { build(:creditcard)  }
      before do
        @authorized = playcasette('authorize.net/void-authorize')  { gateway.authorize }
        @voided   = playcasette('authorize.net/void-success')    { gateway.void(@authorized) }
      end

      it 'should have right values' do
        @authorized.reload.wont_be(:active?)

        @voided.must_be(:voided?)
        @voided.must_be(:active?)
        @voided.amount.must_equal 100
        @voided.transaction_gid.must_equal '2169944463'
      end
    end

    describe "when credit card is invalid" do
      let(:creditcard)  { build(:creditcard)  }

      before do
        @authorized = playcasette('authorize.net/authorize-success')  { gateway.authorize }
        creditcard.number = 2
        @voided   = playcasette('authorize.net/void-failure')    { gateway.void(@authorized) }
      end

      it 'should have right values' do
        @voided.must_be(:nil?)
      end
    end
  end
end
