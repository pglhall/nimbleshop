class CustomFieldAnswer
  module Field
    extend ActiveSupport::Concern

    def custom_field=(custom_field)
      set_custom_field(custom_field)

      extend_module
    end

    # when question_id is assigned extend the module
    def custom_field_id=(question_id)
      super

      extend_module
    end

    # Override Answer initialize method to extend proper Response module
    # For example
    # Answer instance whose question is TextFieldQuestion will extend TextFieldResponse
    def initialize(attributes = nil, options = {})
      super

      extend_module
    end

    # We need to override after_initialize module to force instance to extend proper module
    # ActiveRecord instances are created sometimes using malloc which will not invoke the initialize
    # but they will call after_initialize
    def after_initialize
      extend_module
    end

    def extend_module
      if target_module = module_to_extend
        # Don't include module twice
        kind_of?(target_module) || extend(target_module)

        # Force value coersion for extended module
        #
        # For example
        # if answer is created as shown below
        # case(1)
        # q = NumberQuestion.new
        # a = Answer.new(:question => q, :value => 23.45)
        # a.float_value ==> nil
        # a.value  ==> '23.45'
        #
        # case(2)
        # a = Answer.new(:question => q)
        # a.value = 23.45
        # a.float_value ==> 23.45
        # a.value  ==> '23.45'
        #
        # Above case appears bcoz modules are extended after
        # attributes are assigned. reassign_value method will
        # give the modules to fix this problem please refer
        # to NumberResponse reassign_value
        #
        # Note: currently both cases will work as expected
        reassign_value
      end
    end

    # This method will determine which module to extend
    # Answer instances which are created using select might throw exception
    # For example Answer.find(:conditions => [], :select => "value")
    # retrieve_module_name will throw exception when it tries to access question field
    # This is the only case Answer will fail to extend proper module
    def module_to_extend
      begin
        CustomFieldAnswer::Field.const_get("#{custom_field.field_type.camelize}Field")
      rescue
        nil
      end
    end

    def reassign_value
      self.value = self.value
    end

    module DateField
      def value=(value)
        super

        self.datetime_value = value
      end
    end

    module NumberField
      def value=(value)
        super

        self.number_value = value
      end
    end

    module TextAnswerField
    end
  end
end
