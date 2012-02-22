require 'spec_helper'

describe Shop do

  describe "callbacks" do
    describe "#sanitize_twitter_handle" do
      before { shop.valid? }

      describe "when twitter handler starts with @" do
        let(:shop) { Shop.new(twitter_handle: '@nimbleshop') }

        it { shop.twitter_handle.must_equal 'nimbleshop' }
      end

      describe "when twitter handler starts without @" do
        let(:shop) { Shop.new(twitter_handle: 'nimbleshop') }

        it { shop.twitter_handle.must_equal 'nimbleshop' }
      end
    end
  end

  describe "validations" do
    subject { create(:shop) }
    it {
      must validate_presence_of(:name)
      must validate_presence_of(:theme)
      must validate_presence_of(:default_creditcard_action)

      wont validate_presence_of(:facebook_url)
      wont validate_presence_of(:contact_email)
      #must validate_presence_of(:from_email)
      #must validate_presence_of(:intercept_email)
    }
  end
end
