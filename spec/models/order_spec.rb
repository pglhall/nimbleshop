require 'spec_helper'

describe Order do
  describe "status values" do

    describe 'default value' do
      let(:order)  { create(:order)  }
      it '' do
        order.status.must_equal 'added_to_cart'
      end
    end

    describe '' do
      let(:order)  { create(:order)  }
      before do
        order.update_attributes(email: 'a@example.com')
      end
      it '' do
        order.status.must_equal 'billing_info_provided'
      end
    end

  end
end
