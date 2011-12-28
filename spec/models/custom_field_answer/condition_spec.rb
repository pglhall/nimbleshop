require 'spec_helper'

describe 'conditions' do
  let(:query_sql)  { condition.to_condition.to_sql }

  describe "alias join" do
    let(:condition) { TextCondition.new(op: 'eq', v: 'george', i: 1) }

    it "should create inner join using alias" do
      condition.arel_join(Product.arel_table).to_sql.must_be_like %{
        SELECT FROM "products" INNER JOIN "custom_field_answers" 
        "answers1" ON "answers1"."product_id" = "products"."id"
      }
    end
  end

  describe "text condition" do

    it "should raise operator not supported exception" do
      proc {
        TextCondition.new(op: 'lteq', v: 'george')
      }.must_raise Search::OperatorNotSupported
    end

    describe "#to_condition" do
      describe "#eq" do
        let(:condition) { TextCondition.new(op: 'eq', v: 'george') }

        it "should create query for string equal" do
          query_sql.must_be_like %{
            "answers"."value" ILIKE 'george'
          }
        end
      end

      describe "#starts" do
        let(:condition) { TextCondition.new(op: 'starts', v: 'george',i: 1) }

        it "should create query for string starts with" do
          query_sql.must_be_like %{
            "answers1"."value" ILIKE 'george%'
          }
        end
      end

      describe "#ends" do
        let(:condition) { TextCondition.new(op: 'ends', v: 'george',i: 2) }

        it "should create query for string starts with" do
          query_sql.must_be_like %{
            "answers2"."value" ILIKE '%george'
          }
        end
      end

      describe "#contains" do
        let(:condition) { TextCondition.new(op: 'contains', v: 'george',i: 4) }

        it "should create query for string starts with" do
          query_sql.must_be_like %{
            "answers4"."value" ILIKE '%george%'
          }
        end
      end
    end
  end

  describe "number condition" do

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

  describe "date condition" do
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
end
