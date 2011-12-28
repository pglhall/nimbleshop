require 'spec_helper'

describe 'conditions' do
  let(:query_sql)  { condition.to_condition.to_sql }

  describe "alias join" do
    let(:condition) { Search::TextCondition.new(op: 'eq', v: 'george', i: 1) }

    it "should create inner join using alias" do
      condition.arel_join(Product.arel_table).to_sql.must_be_like %{
        SELECT FROM "products" INNER JOIN "custom_field_answers" 
        "answers1" ON "answers1"."product_id" = "products"."id"
      }
    end
  end
end

describe "text condition" do

  let(:query_sql)  { condition.to_condition.to_sql }

  it "should raise operator not supported exception" do
    proc {
      Search::TextCondition.new(op: 'lteq', v: 'george')
    }.must_raise Search::OperatorNotSupported
  end

  describe "#to_condition" do
    describe "#eq" do
      let(:condition) { Search::TextCondition.new(op: 'eq', v: 'george') }

      it "should create query for string equal" do
        query_sql.must_be_like %{
            "answers"."value" ILIKE 'george'
        }
      end
    end

    describe "#starts" do
      let(:condition) { Search::TextCondition.new(op: 'starts', v: 'george',i: 1) }

      it "should create query for string starts with" do
        query_sql.must_be_like %{
            "answers1"."value" ILIKE 'george%'
        }
      end
    end

    describe "#ends" do
      let(:condition) { Search::TextCondition.new(op: 'ends', v: 'george',i: 2) }

      it "should create query for string starts with" do
        query_sql.must_be_like %{
            "answers2"."value" ILIKE '%george'
        }
      end
    end

    describe "#contains" do
      let(:condition) { Search::TextCondition.new(op: 'contains', v: 'george',i: 4) }

      it "should create query for string starts with" do
        query_sql.must_be_like %{
            "answers4"."value" ILIKE '%george%'
        }
      end
    end
  end
end
