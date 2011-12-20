require 'spec_helper'

describe Shop do
  describe "twitter values" do

    describe "with @" do
      let(:shop)    { create(:shop, twitter_handle: '@nimbleshop')    }
      it '' do
        shop.twitter_handle.must_equal 'nimbleshop'
      end
    end
    describe "without @" do
      let(:shop)    { create(:shop, twitter_handle: 'nimbleshop')    }
      it '' do
        shop.twitter_handle.must_equal 'nimbleshop'
      end
    end

  end
end
