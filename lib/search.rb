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

    def summarize(args)
      to_conditions(args).map(&:summary).join(' and ').capitalize
    end

    def search(args)
      conditions = to_conditions(args)
      relation   = merge_joins(conditions).where(merge_where(conditions))
      relation   = relation.project(Arel.sql("products.*"))

      find_by_sql(relation.to_sql)
    end

    private

    def to_conditions(conditions)
      result = []
      Array.wrap(conditions).each_with_index do | condition, index |
        result << to_condition(condition, index)
      end
      result
    end

    def to_condition(params, index)
      field, hash = params.to_a.first
      klass = resolve_condition_klass(field)
      klass.new(hash.merge(i: index, name: field)) 
    end

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
