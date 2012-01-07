module Search
  class BaseField
    attr_accessor :condition
    delegate :arel_field, :to => :condition

    def initialize(condition)
      self.condition = condition
    end

    def valid_operator?(operator)
      valid_operators.include?(operator.to_s)
    end

    def where(proxy = nil)
      clause = send(condition.operator, condition.value)
      proxy ? proxy.and(clause) : clause
    end
  end
end
