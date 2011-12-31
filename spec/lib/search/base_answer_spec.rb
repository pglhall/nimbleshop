require 'spec_helper'

describe 'base search' do
  let(:query_sql)  { condition.to_condition.to_sql }

  describe "alias join" do
    let(:condition) { Search::TextAnswer.new(op: 'eq', v: 'george', i: 1) }

    it "should create inner join using alias" do
      condition.arel_join(Product.arel_table).to_sql.must_be_like %{
        SELECT FROM "products" INNER JOIN "custom_field_answers" 
        "answers1" ON "answers1"."product_id" = "products"."id"
      }
    end
  end
end

describe "#summarize" do
  describe "#eq" do
    let(:condition) { Search::NumberAnswer.new(name: 'price', op: 'eq', v: 24) }

    it "should say price is equal to 24" do
      condition.summary.must_equal 'price is equal to 24'
    end
  end

  describe "#lt" do
    let(:condition) { Search::NumberAnswer.new(name: 'price', op: 'lt', v: 24) }

    it "should say price is equal to 24" do
      condition.summary.must_equal 'price is less than 24'
    end
  end
end
