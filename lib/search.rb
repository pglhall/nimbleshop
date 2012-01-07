require 'search/core_field_strategy'
require 'search/custom_field_strategy'
require 'search/base_field'
require 'search/text_field'
require 'search/number_field'
require 'search/date_field'

module Search  
  extend ActiveSupport::Concern

  included do
    attr_reader :query_column, :query_strategy

    attr_accessor :index

    delegate :where, :to => :query_strategy

    validate          :validate_operator

    after_initialize  :set_strategy
  end

  module InstanceMethods
    def validate_operator
      unless @query_strategy.valid_operator?(operator)
        self.errors.add(:operator, :invalid)
      end
    end

    def name=(val)
      val = val.try(:to_s)
      if super(val)
        set_strategy
      end
    end

    def set_strategy
      set_join_module
      @query_strategy = self.class.const_get("#{field_type.classify}Field").new(self)
    end

    def summary
      I18n.t(self.operator.to_sym, field: localized_name, value: self.value)
    end

    private

    def set_join_module
      extend(custom_field? ? CustomFieldStrategy : CoreFieldStrategy)
    end

    def arel_field
      target_table.send(:[], query_column)
    end

    def custom_field?
      self.name =~ /\d+/
    end

    def custom_field
      if custom_field?
      end
    end
  end
end
