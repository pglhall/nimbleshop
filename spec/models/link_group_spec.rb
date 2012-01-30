require 'spec_helper'

describe LinkGroup do

  describe "validations" do
    let(:link_group) { create(:link_group) }

    it 'should save given correct name' do
      link_group.save.must_equal true
    end

    it 'should not save without a name' do
      link_group.name = ""
      link_group.save.must_equal false
    end   
     
  end
end
