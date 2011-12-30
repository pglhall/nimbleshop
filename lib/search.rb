require 'search/base_answer'
require 'search/text_answer'
require 'search/number_answer'
require 'search/date_answer'

require 'search/base_field'
require 'search/text_field'
require 'search/number_field'
require 'search/date_field'

module Search
  extend ActiveSupport::Concern

  class OperatorNotSupported < StandardError #:nordoc
  end

  module ClassMethods

    def search(args = {})
      conditions = to_conditions(args)
      relation   = merge_joins(conditions).where(merge_where(conditions))
      relation   = relation.project(Arel.sql("products.*"))

      Product.find_by_sql(relation.to_sql)
    end

    def to_conditions(conditions)
      index = 0 

      conditions.map do | (field, params) |
        index = index + 1
        klass = resolve_condition_klass(field)
        klass.new(params.merge(i: index, name: field)) 
      end
    end

    private

    def merge_joins(conditions)
      conditions.inject(nil) { | relation, condition| condition.arel_join(arel_table, relation) }
    end

    def merge_where(conditions)
      conditions.inject(nil) do | t, condition |
        t.nil? ? condition.to_condition : t.and(condition.to_condition)
      end
    end

    def resolve_condition_klass(field)
      klass = case field
      when /(name|description)/
        'TextField'
      when /price/
        'NumberField'
      else
        "#{CustomField.find(field.gsub(/q/,'')).field_type.camelize}Answer"
      end

      const_get(klass)
    end
  end
end
