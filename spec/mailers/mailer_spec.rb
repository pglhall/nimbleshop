require "spec_helper"

describe Mailer do

  before do
    ActionMailer::Base.deliveries.clear
  end

  let(:order) { create(:order) }


end
