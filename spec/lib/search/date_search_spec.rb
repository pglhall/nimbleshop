require 'spec_helper'

describe "date condition" do
  let(:query_sql)  { condition.to_condition.to_sql }
  describe "#to_condition" do
    describe "#eq" do
      let(:condition) { DateCondition.new(op: 'eq', v: '1/2/2009') }

      it "should create query for date equal" do
        query_sql.must_be_like %{
            "answers"."datetime_value" = '1/2/2009'
        }
      end
    end

    describe "#lt" do
      let(:condition) { DateCondition.new(op: 'lt', v: '1/2/2009') }

      it "should create query for date less than" do
        query_sql.must_be_like %{
            "answers"."datetime_value" < '1/2/2009'
        }
      end
    end

    describe "#gt" do
      let(:condition) { DateCondition.new(op: 'gt', v: '1/2/2009') }

      it "should create query for date greater than" do
        query_sql.must_be_like %{
            "answers"."datetime_value" > '1/2/2009'
        }
      end
    end

    describe "#lteq" do
      let(:condition) { DateCondition.new(op: 'lteq', v: '1/2/2009') }

      it "should create query for date less than equal" do
        query_sql.must_be_like %{
            "answers"."datetime_value" <= '1/2/2009'
        }
      end
    end

    describe "#gteq" do
      let(:condition) { DateCondition.new(op: 'gteq', v: '1/2/2009') }

      it "should create query for date greater than equal" do
        query_sql.must_be_like %{
            "answers"."datetime_value" >= '1/2/2009'
        }
      end
    end
  end
end
