require 'spec_helper'

describe LineItem do
  describe 'variant present' do
    let(:product) { create(:product, variants_enabled: true) }
    let(:order) { create(:order) }
    let(:variant) { create(:variant, product: product) }
    before do
      order.add(product, record)

    end
  end
end
