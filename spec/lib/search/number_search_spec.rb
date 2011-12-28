require 'spec_helper'

describe "number condition" do

  let(:query_sql)  { condition.to_condition.to_sql }

  it "should raise operator not supported exception" do
    proc {
      NumberCondition.new(op: 'contains', v: 'george')
    }.must_raise Search::OperatorNotSupported
  end

  describe "#to_condition" do
    describe "#eq" do
      let(:condition) { NumberCondition.new(op: 'eq', v: 24) }

      it "should create query for number equal" do
        query_sql.must_be_like %{
            "answers"."number_value" = 24
        }
      end
    end

    describe "#lt" do
      let(:condition) { NumberCondition.new(op: 'lt', v: 24) }

      it "should create query for number less than" do
        query_sql.must_be_like %{
            "answers"."number_value" < 24
        }
      end
    end

    describe "#gt" do
      let(:condition) { NumberCondition.new(op: 'gt', v: 24) }

      it "should create query for number greater than" do
        query_sql.must_be_like %{
            "answers"."number_value" > 24
        }
      end
    end

    describe "#lteq" do
      let(:condition) { NumberCondition.new(op: 'lteq', v: 24) }

      it "should create query for number less than equal" do
        query_sql.must_be_like %{
            "answers"."number_value" <= 24
        }
      end
    end

    describe "#gteq" do
      let(:condition) { NumberCondition.new(op: 'gteq', v: 24) }

      it "should create query for number greater than equal" do
        query_sql.must_be_like %{
            "answers"."number_value" >= 24
        }
      end
    end
  end
end

