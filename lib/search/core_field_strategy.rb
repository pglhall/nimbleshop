module Search
  module CoreFieldStrategy
    def join(proxy)
      proxy
    end

    def target_table
      unless @_target
        @_target = Product.arel_table
      end
      @_target
    end

    def query_column
      self.name.try(:to_sym)
    end

    def field_type
      if query_column == :price
        'number'
      else
        'text'
      end
    end

    def localized_name
      self.name
    end
  end
end
