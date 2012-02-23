module InquirerMethods
  extend ActiveSupport::Concern
  module ClassMethods
    def inquire_method(*attrs)
      attrs.each do | attr |
        module_eval <<-END
            def #{attr}
              ActiveSupport::StringInquirer.new(super)
            end
          END
      end
    end
  end
end
